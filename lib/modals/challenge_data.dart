import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:pronounce_challenge/api/admob_manager.dart';
import 'package:pronounce_challenge/modals/user_preferences.dart';
import 'package:pronounce_challenge/screens/results_screen.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../screens/challenge_screen.dart';
import '../screens/selection_screen.dart';
import 'constants.dart';

class ChallengeData extends ChangeNotifier {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String? localFilePath;
  String? localAudioCacheURI;

  //if its true ads will not be showed to the user
  static bool? _adsRemovalPurchased = UserPreferences.getRemovalAdsBool();

  get adsRemovalPurchased => _adsRemovalPurchased;

  String _screenContext = ChallengeScreen.id;

  get screenContext => _screenContext;

  void changeScreenContext(String newScreenContext) {
    _screenContext = newScreenContext;
    notifyListeners();
  }

  //usally this will be set only once to true, unless the user asks for refund
  void setRemovalPurchased(bool state) {
    _adsRemovalPurchased = state;

    print('Ads Removal State= $state');
    notifyListeners();
  }

  FlutterTts flutterTts = FlutterTts();
  bool _showEvilWordsMenu = false;

  var challengeQnt;

  get showEvilWordsMenu => _showEvilWordsMenu;

  void setShowEvilWordMenu(bool state) {
    _showEvilWordsMenu = state;
    notifyListeners();
  }

  void nextRandomText() {
    changeChallengeNumber();
    resetTrys();
    setresultColor(kPrimaryColor);

    changeTextInput(pressText);
    int randomIndex = Random().nextInt(all.length - 1);
    changeRandomText(all[randomIndex]);
  }

  void speak() async {
    //  print(await flutterTts.getLanguages);
    await flutterTts.setLanguage(languageChoosed);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(randomText);
  }

  dynamic admob = AdManager();

  void speakEvil() async {
    //  print(await flutterTts.getLanguages);
    await flutterTts.setLanguage(languageChoosed);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(evilwordInIndexText);
  }

  void speakSlow() async {
    await flutterTts.setLanguage(languageChoosed);
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.1);
    await flutterTts.speak(randomText);
  }

  void speakSlowEvil() async {
    await flutterTts.setLanguage(languageChoosed);
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.1);
    await flutterTts.speak(evilwordInIndexText);
  }

  int _challengeNumber = 0;

  get challengeNumber => _challengeNumber;

  void changeChallengeNumber() {
    _challengeNumber++;
    notifyListeners();
  }

  void resetChallengeNumber() {
    _challengeNumber = 0;
    notifyListeners();
  }

  void checkResult(context) {
    if (_randomText == _textInput) {
      stopListening();
      addPoints();
      audioCache.play('right.wav');
      setresultColor(Colors.green);
      if (challengeQnt == _challengeNumber) showAdstuff(context);

      notifyListeners();
    } else {
      print("did not match");
      audioCache.play('wrong.wav');
      setresultColor(Colors.redAccent);
    }
  }

  void checkResultEvil() {
    if (_evilwordInIndexText == _textInput) {
      addPoints();
      print(points);
      notifyListeners();
    }
  }

  int _trys = 0;

  get trys => _trys;

  void resetTrys() {
    _trys = 0;
    notifyListeners();
  }

  void addTrys(BuildContext context) async {
    if (_trys == 3 && !evilWordArray.contains(_randomText)) {
      addEvilWord(_randomText, context);
    }
    _trys++;
    notifyListeners();
  }

  void removeTrys() {
    if (_trys >= 1) {
      _trys--;
      notifyListeners();
    }
  }

  List<String> _evilWordArray = [];

  List<String> get evilWordArray => _evilWordArray;

  void updateEvilWordsFromSharedPreferences() {
    _evilWordArray = UserPreferences.getEvilWordList()!;
    notifyListeners();
  }

  void showSnackBar(context, text, bool removeorAdd) {
    String RemoveText = "Removed from 'Evil Words' Menu";
    String AddText = "Added to 'Evil Words' in the Menu";
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "'${capitalize(text)}' ${removeorAdd == true ? AddText : RemoveText}",
        style: TextStyle(fontSize: 18),
      ),
    ));
  }

  void addEvilWord(String randomText, BuildContext context) async {
    showSnackBar(context, randomText, true);
    print('$randomText added to evil words');
    setShowEvilWordMenu(true);
    evilWordsCount++;
    evilWordArray.add(randomText);
    await UserPreferences.setEvilWords(_evilWordArray);
    notifyListeners();
  }

  int firstTry = 0;
  int secondTry = 0;
  int lastTry = 0;
  int evilWordsCount = 0;

  void resetWorldConts() {
    firstTry = 0;
    secondTry = 0;
    lastTry = 0;
    evilWordsCount = 0;
  }

  double _points = 0.0;

  get points => _points;

  void addPoints() {
    if (_trys == 1) {
      _points = _points + 2.0;
      firstTry++;
      notifyListeners();
    } else if (_trys == 2) {
      _points = _points + 1.0;
      secondTry++;
      notifyListeners();
    } else if (_trys == 3) {
      _points = _points + 0.5;
      lastTry++;
      notifyListeners();
    } else {
      print(evilWordsCount);
      _points = _points;

      notifyListeners();
    }
  }

  void resetPoints() {
    _points = 0.0;
  }

  Color _resultColor = kPrimaryColor;

  get resultColor => _resultColor;

  void setresultColor(Color newColor) {
    _resultColor = newColor;
    notifyListeners();
  }

  bool _showRewardAd = false;

  get showRewardAd => _showRewardAd;

  void setShowRewardAd(bool state) {
    _showRewardAd = state;
    notifyListeners();
  }

  void showAdstuff(context) {
    bool? _result = UserPreferences.getRemovalAdsBool();
    if (challengeNumber == challengeQnt) {
      Timer(Duration(seconds: 1), () {
        try {
          _result == null ? admob!.showRewardedAd() : null;
        } catch (e) {
          print(e);
          try {
            _result == null ? admob!.showInterstitial() : null;
          } catch (e) {
            print(e);
          }
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ResultsScreen(
                    contextscreen: ChallengeScreen(
                      challengeQnt: challengeQnt,
                    ),
                  )),
          ModalRoute.withName("" + SelectionScreen.id),
        );
      });
    } else {
      nextRandomText();
    }
  }

  void checkAnswer(context) {
    if (_randomText == _textInput) {
      changeListening(false);

      changeListening(false);
      notifyListeners();
    } else if (_textInput == "...Try Again" ||
        _textInput == "Processing..." ||
        _textInput == "Listening..." ||
        _textInput == "Press the Microphone Button") {
      setresultColor(kPrimaryColor);
      notifyListeners();
    } else {
      audioCache.play('wrong.wav');
      setresultColor(Colors.redAccent);
      changeListening(false);
      notifyListeners();
    }
  }

  String _evilwordInIndexText = "tet";

  String get evilwordInIndexText => _evilwordInIndexText;

  void setevilWordIndexText(int index) {
    _evilwordInIndexText = evilWordArray[index].trim();
    notifyListeners();
  }

  void resetEvilWordArrayOneUseOnly() {
    _evilWordArray = [];
    notifyListeners();
  }

  void removeEvilWordInIndex(int newIndex) {
    print(_evilwordInIndexText);

    evilWordArray.remove(_evilwordInIndexText);
    setevilWordIndexText(newIndex);
    print(evilWordArray);

    notifyListeners();
  }

  void checkAnswerEvilWords() {
    print("$_evilwordInIndexText == $_textInput");
    if (_evilwordInIndexText == _textInput) {
      print('playing again');
      audioCache.play('right.wav');
      setresultColor(Colors.green);
    } else if (_textInput == "...Try Again" ||
        _textInput == "..." ||
        _textInput == "Press the Microphone Button") {
      print('playing again ag');

      setresultColor(kPrimaryColor);
    } else {
      print('playing again addd');
      audioCache.play('wrong.wav');
      setresultColor(Colors.redAccent);
    }
  }

  bool _isListening = false;

  get isListening => _isListening;

  void changeListening(bool listeningState) {
    _isListening = listeningState;
    notifyListeners();
  }

  String _textInput = " ";

  get textInput => _textInput;

  void changeTextInput(String textd) {
    _textInput = textd;
    notifyListeners();
  }

  String _language = "en-US";

  get languageChoosed => _language;

  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  String _randomText = "test";

  get randomText => _randomText;

  void changeRandomText(String newRandomText) {
    print(newRandomText);
    _randomText = newRandomText.toLowerCase();

    notifyListeners();
  }

  String pressText = "Press the Microphone Button";

  /// CUIDADO PUTEIRO ABAIXO
  /// daqui em diante vai virar um puteiro do novo microphone
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';
  var other = RegExp('^[1-9]');

  /// This has to happen only once per app
  void initSpeech(context) async {
    speechEnabled = await speechToText.initialize(
      onStatus: (val) {
        statusListener(val, context);
      },
      onError: errorHandler,
    );
    await _getLanguageIndex();
    notifyListeners();
  }

  Future<void> _getLanguageIndex() async {
    var locales = await speechToText.locales();
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
  void statusListener(val, context) {
    print('onStatus:$val');
    if (val == "listening") {
      setresultColor(kPrimaryColor);
      addTrys(context);
      changeTextInput("Listening...");
      changeListening(true);
    } else if (val == "notListening") {
      if (Platform.isIOS) {
        changeTextInput("Processing...");
      }
    } else {
      if (textInput == "Listening..." || textInput == "Processing...") {
        changeTextInput('Nothing heard...');

        removeTrys();
        changeListening(false);
        stopListening();
      }
    }
    notifyListeners();
  }

  /// error handler
  void errorHandler(SpeechRecognitionError val) {
    print('onError:${val.errorMsg} aaaaaa');
    removeTrys();

    changeTextInput("...Nothing heard");
    stopListening();
    notifyListeners();
  }

  /// Each time to start a speech recognition session
  void startListening(context) async {
    await speechToText.listen(
        onResult: (val) {
          _onSpeechResult(val, context);
        },
        localeId: languageChoosed,
        cancelOnError: true,
        pauseFor: Duration(milliseconds: 2500));
    notifyListeners();
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    await speechToText.stop();
    notifyListeners();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result, context) {
    print("this is the result:$result");
    if (result.finalResult && result.confidence == -1.0) {
      changeTextInput("Didn't undestand....");
    } else if (result.finalResult) {
      /// this one change the number like: 11 to eleven,
      if (result.recognizedWords.contains(other)) {
        String trimadaStringada =
            NumberToWord().convert('en-in', int.parse(result.recognizedWords));
        changeTextInput(trimadaStringada.trim());
      } else {
        changeTextInput(result.recognizedWords.toLowerCase());
      }
      screenContext == ChallengeScreen.id
          ? checkResult(context)
          : checkAnswerEvilWords();
    } else {
      if (Platform.isAndroid) {
        changeTextInput('Processing...');
      }
    }
  }

  Icon iconHandler() {
    Icon icon;
    if (speechToText.isNotListening) {
      icon = Icon(Icons.mic_off, size: 40);
    } else {
      icon = Icon(Icons.mic, size: 40);
    }
    return icon;
  }
}
