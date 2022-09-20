import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  read(String? key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key!).toString());
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    print(value);
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
