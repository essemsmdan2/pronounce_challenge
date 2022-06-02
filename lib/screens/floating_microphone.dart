import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:pronounce_challenge/constants.dart';
import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:pronounce_challenge/screens/challenge_screen.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class FloatingMicrophoneInput extends StatefulWidget {
  var screenContext;

  FloatingMicrophoneInput({Key? key, required this.screenContext}) : super(key: key);

  @override
  State<FloatingMicrophoneInput> createState() => _FloatingMicrophoneInputState();
}

class _FloatingMicrophoneInputState extends State<FloatingMicrophoneInput> {
  stt.SpeechToText? _speech;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeData>(
      builder: (BuildContext context, chData, Widget? child) {
        Future<void> _getLanguageIndex() async {
          var locales = await _speech!.locales();
          var localesId = [];
          for (int i = 0; i < locales.length; i++) {
            //log("${locales[i].localeId} $i ${locales[i].name} ");
            localesId.add(locales[i].localeId);
            //
          }

          //print(localesId.indexOf(context.read<ChallengeData>().languageChoosed));
          //print(localesId[60]);
        }

        void _listen() async {
          chData.setresultColor(kPrimaryColor);
          widget.screenContext == ChallengeScreen.id ? chData.addTrys(true, context) : chData.addTrys(false, context);
          var other = RegExp('^[1-9]');
          if (!chData.isListening) {
            bool available = await _speech!.initialize(
              onStatus: (val) {
                print('onStatus:$val');
                if (val == "listening") {
                  chData.changeTextInput("Listening...");
                } else if (val == "notListening") {
                  chData.changeListening(false);
                } else {
                  chData.changeListening(false);
                }
              },
              onError: (val) {
                chData.changeListening(false);
                chData.removeTrys();
                chData.changeTextInput("...Nothing heard");
              },
            );
            if (available) {
              print('available');
              chData.changeListening(true);

              await _getLanguageIndex();
              await _speech!.listen(
                  localeId: chData.languageChoosed,
                  listenFor: Duration(seconds: 30),
                  pauseFor: Duration(seconds: 3),
                  partialResults: true,
                  onResult: (val) {
                    print(val);
                    if (val.hasConfidenceRating && val.confidence > 0) {
                      if (val.recognizedWords.contains(other)) {
                        String trimadaStringada = NumberToWord().convert('en-in', int.parse(val.recognizedWords));
                        chData.changeTextInput(trimadaStringada.trim());
                      } else {
                        chData.changeTextInput(val.recognizedWords.toLowerCase());
                      }

                      widget.screenContext == ChallengeScreen.id ? chData.checkAnswer(context) : chData.checkAnswerEvilWords();
                      chData.changeListening(false);
                      widget.screenContext == ChallengeScreen.id ? chData.checkResult() : chData.checkResultEvil();
                    }
                  });
            } else {
              chData.removeTrys();
              chData.changeListening(false);
              chData.changeTextInput("Didn't Undestand...");
              _speech!.stop();
            }
          }
        }

        return SizedBox(
          height: 170,
          child: AvatarGlow(
            animate: chData.isListening,
            glowColor: Theme.of(context).primaryColor,
            endRadius: 75,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
                onPressed: chData.resultColor == Colors.green || chData.isListening ? null : _listen,
                child: Icon(
                  Icons.mic,
                  size: 40,
                  color: chData.resultColor == Colors.green ? kPrimaryColor.shade300 : Colors.white,
                )),
          ),
        );
      },
    );
  }
}
