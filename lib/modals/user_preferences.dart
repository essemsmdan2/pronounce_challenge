import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;
  static const String _keyEvilWords = "evilWords";
  static const String _firstTimeBool = "firstTime";
  static const String _removeAdsBool = "removeAds";

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  // RESPONSÁVEL PELA SETAGEM DE REMOÇÃO DE ADS
  static Future setRemovalAds() async => await _preferences.setBool(_removeAdsBool, true);
  static bool? getRemovalAdsBool() {
    return _preferences.getBool(_removeAdsBool);
  }

  //RESPONSAVEL PELA SETAGEM INICIAL
  static Future setFirstTime() async => await _preferences.setBool(_firstTimeBool, false);
  static bool? getFirstTimeBool() {
    return _preferences.getBool(_firstTimeBool);
  }

  //RESPONSAVEL PELO SET EVIL WORDS

  static Future setEvilWords(List<String> evilWords) async => await _preferences.setStringList(_keyEvilWords, evilWords);
  static Future resetEvilWords() async => await _preferences.setStringList(_keyEvilWords, []);
  static List<String>? getEvilWordList() => _preferences.getStringList(_keyEvilWords);
}
