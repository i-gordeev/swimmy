import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _instance;

  static Future<void> init() async {
    _instance ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await _instance?.setString(key, value) ?? false;
  }

  static Future<bool> setInt(String key, int value) async {
    return await _instance?.setInt(key, value) ?? false;
  }

  static Future<bool> setDouble(String key, double value) async {
    return await _instance?.setDouble(key, value) ?? false;
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _instance?.setBool(key, value) ?? false;
  }

  static Future<bool> setList(String key, List value) async {
    return await _instance?.setString(key, json.encode(value)) ?? false;
  }

  static Future<bool> setMap(String key, Map<String, dynamic> value) async {
    return await _instance?.setString(key, json.encode(value)) ?? false;
  }

  static Future<void> remove(String key) async {
    await _instance?.remove(key);
  }

  static String? getString(String key) => _instance?.getString(key);

  static int? getInt(String key) => _instance?.getInt(key);

  static double? getDouble(String key) => _instance?.getDouble(key);

  static bool? getBool(String key) => _instance?.getBool(key);

  static List? getList(String key) {
    final jsonData = _instance?.getString(key);
    return jsonData != null ? json.decode(jsonData) : null;
  }

  static Map<String, dynamic>? getMap(String key) {
    final jsonData = _instance?.getString(key);
    return jsonData != null ? json.decode(jsonData) : null;
  }
}
