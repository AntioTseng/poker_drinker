import 'package:flutter/foundation.dart';

class AppLocale {
  static final ValueNotifier<String> code = ValueNotifier<String>('zh');

  static void set(String newCode) {
    if (code.value == newCode) return;
    code.value = newCode;
  }
}
