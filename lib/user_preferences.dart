import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;
  static const String _keyEvilWords = "evilWords";
  static const String _firstTimeBool = "firstTime";

  static Future init() async => _preferences = await SharedPreferences.getInstance();

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
