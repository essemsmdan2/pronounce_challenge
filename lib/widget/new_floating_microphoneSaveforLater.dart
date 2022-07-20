import 'package:flutter/material.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:pronounce_challenge/modals/constants.dart';
import 'package:pronounce_challenge/screens/challenge_screen.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../modals/challenge_data.dart';

class newFloatingMic extends StatefulWidget {
  static String id = "newfloatingmic";

  var screenContext;

  newFloatingMic({Key? key, this.screenContext}) : super(key: key);

  @override
  _newFloatingMic createState() => _newFloatingMic();
}

class _newFloatingMic extends State<newFloatingMic> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  var other = RegExp('^[1-9]');

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: statusListener,
      onError: errorHandler,
    );
    await _getLanguageIndex();
    setState(() {});
  }

  /// used to update the languages of the device (i supose) without this check the language didnt work
  Future<void> _getLanguageIndex() async {
    var locales = await _speechToText.locales();
    var localesId = [];
    for (int i = 0; i < locales.length; i++) {
      //log("${locales[i].localeId} $i ${locales[i].name} ");
      localesId.add(locales[i].localeId);
      //
    }

    //print(localesId.indexOf(context.read<ChallengeData>().languageChoosed));
    //print(localesId[60]);
  }

  /// resolve various status listeners
  void statusListener(val) {
    print('onStatus:$val');
    if (val == "listening") {
      Provider.of<ChallengeData>(context, listen: false)
          .setresultColor(kPrimaryColor);
      Provider.of<ChallengeData>(context, listen: false).addTrys(context);
      Provider.of<ChallengeData>(context, listen: false)
          .changeTextInput("Listening...");
      Provider.of<ChallengeData>(context, listen: false).changeListening(true);
    } else if (val == "notListening") {
      Provider.of<ChallengeData>(context, listen: false)
          .changeTextInput("Tap the microphone to start listening...");
      Provider.of<ChallengeData>(context, listen: false).changeListening(false);
    } else {
      Provider.of<ChallengeData>(context, listen: false).changeListening(false);
    }
  }

  /// error handler
  void errorHandler(val) {
    print('onError:$val aaaaaa');
    Provider.of<ChallengeData>(context, listen: false).removeTrys();
    Provider.of<ChallengeData>(context, listen: false)
        .changeTextInput("...Nothing heard");
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId:
            Provider.of<ChallengeData>(context, listen: false).languageChoosed,
        cancelOnError: true,
        pauseFor: Duration(milliseconds: 1500));
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    print(result);

    /// this one change the number like: 11 to eleven,
    if (result.recognizedWords.contains(other)) {
      String trimadaStringada =
          NumberToWord().convert('en-in', int.parse(result.recognizedWords));
      Provider.of<ChallengeData>(context, listen: false)
          .changeTextInput(trimadaStringada.trim());
    } else {
      Provider.of<ChallengeData>(context, listen: false)
          .changeTextInput(result.recognizedWords.toLowerCase());
    }
    widget.screenContext == ChallengeScreen.id
        ? Provider.of<ChallengeData>(context, listen: false)
            .checkResult(context)
        : Provider.of<ChallengeData>(context, listen: false)
            .checkAnswerEvilWords();
  }

  Icon iconHandler() {
    Icon icon;
    if (_speechToText.isNotListening) {
      icon = Icon(Icons.mic_off, size: 40);
    } else {
      icon = Icon(Icons.mic, size: 40);
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop

            _speechToText.isNotListening
                ? _startListening
                : Provider.of<ChallengeData>(context, listen: false)
                            .resultColor ==
                        Colors.green
                    ? null
                    : _stopListening,
        tooltip: 'Listen',
        child: iconHandler(),
      ),
    );
  }
}
