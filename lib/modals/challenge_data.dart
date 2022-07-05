import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pronounce_challenge/screens/results_screen.dart';
import 'package:pronounce_challenge/user_preferences.dart';
import 'package:pronounce_challenge/widget/admob_manager.dart';
import '../constants.dart';
import '../screens/challenge_screen.dart';
import '../screens/selection_screen.dart';

class ChallengeData extends ChangeNotifier {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String? localFilePath;
  String? localAudioCacheURI;

  //if its true ads will not be showed to the user
  static bool _adsRemovalPurchased = false;
  get adsRemovalPurchased => _adsRemovalPurchased;

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
    notifyListeners();
  }

  void speak() async {
    //  print(await flutterTts.getLanguages);
    await flutterTts.setLanguage(languageChoosed);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(randomText);
  }

  var admob = _adsRemovalPurchased ? null : AdManager();

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
  }

  void resetChallengeNumber() {
    _challengeNumber = 0;
  }

  void checkResult() {
    if (_randomText == _textInput) {
      addPoints();
      print(points);
    }
  }

  void checkResultEvil() {
    if (_evilwordInIndexText == _textInput) {
      addPoints();
      print(points);
    }
  }

  int _trys = 0;
  get trys => _trys;
  void resetTrys() {
    _trys = 0;
    notifyListeners();
  }

  void addTrys(bool isChallengeScreen, BuildContext context) async {
    if (_trys == 3 && isChallengeScreen && !evilWordArray.contains(_randomText)) {
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
  }

  bool _showRewardAd = false;
  get showRewardAd => _showRewardAd;
  void setShowRewardAd(bool state) {
    _showRewardAd = state;
    notifyListeners();
  }

  void showAdstuff(context) {
    if (challengeNumber == challengeQnt) {
      Timer(Duration(seconds: 1), () {
        try {
          admob!.showRewardedAd();
        } catch (e) {
          print(e);
          try {
            admob!.showInterstitial();
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
      print('playing again');
      audioCache.play('right.wav');
      setresultColor(Colors.green);
      if (challengeQnt == _challengeNumber) showAdstuff(context);
      notifyListeners();
    } else if (_textInput == "...Try Again" || _textInput == "Listening..." || _textInput == "Press the Microphone Button") {
      setresultColor(kPrimaryColor);
      notifyListeners();
    } else {
      audioCache.play('wrong.wav');
      setresultColor(Colors.redAccent);
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
    } else if (_textInput == "...Try Again" || _textInput == "..." || _textInput == "Press the Microphone Button") {
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
}
