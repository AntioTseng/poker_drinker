import 'dart:convert';
import 'package:flutter/services.dart';

class PyramidPokerStrings {
  static Map<String, String>? _localizedStrings;

  static Future<void> load([String locale = 'zh']) async {
    final String jsonString = await rootBundle.loadString(
      'assets/i18n/strings_${locale}.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }

  static String get(String key) {
    return _localizedStrings?[key] ?? key;
  }

  static String format(String key, Map<String, Object?> params) {
    var template = get(key);
    params.forEach((paramKey, value) {
      template = template.replaceAll('{${paramKey}}', value?.toString() ?? '');
    });
    return template;
  }
}
