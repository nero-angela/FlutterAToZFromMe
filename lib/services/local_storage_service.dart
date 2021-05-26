import 'dart:convert';

import 'package:from_me/models/letter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {

  // 기기에 저장하고 불러오는 것을 도와주는 SharedPreferences 변수입니다.
  // 나중에 init()함수에서 _sharedPreferences 할당해주기 때문에 late이라고 명시해줍니다.
  static late final SharedPreferences _sharedPreferences;
  
  // 편지들을 저장하는 key
  static final _lettersKey = 'letters';

  // SharedPreferences.getInstance()가 Future를 반환하기 때문에
  // async인 init() 함수를 만들었습니다.
  // main.dart에서 앱이 시작되기 전에 호출해줍니다.
  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static void saveLetters(List<Letter> letters) {
    List<String> stringLetters = [];
    for (final letter in letters) {
      // Letter -> Map
      final mapLetter = letter.toJson();

      // Map -> String
      final stringLetter = json.encode(mapLetter);
      stringLetters.add(stringLetter);
    }

    // save
    _sharedPreferences.setStringList(_lettersKey, stringLetters);
  }

  static List<Letter> loadLetters() {
    // load
    List<String> stringLetters = _sharedPreferences.getStringList(_lettersKey) ?? [];
    
    List<Letter> letters = [];
    for (final stringLetter in stringLetters) {
      // string -> Map
      final mapLetter = json.decode(stringLetter);

      // Map -> Letter
      final letter = Letter.fromJson(mapLetter);
      letters.add(letter);
    }

    return letters;
  }
}
