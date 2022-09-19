import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    return json.decode(str!);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  update(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    prefs.setString(key, json.encode(value));
  }
}
