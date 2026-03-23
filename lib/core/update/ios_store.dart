import 'package:flutter/services.dart';

class IOSStore {
  static const MethodChannel _channel = MethodChannel('com.poink.app/store');

  /// Presents the App Store page inside the app using SKStoreProductViewController on iOS.
  /// Provide the numeric App Store id (e.g. '123456789').
  static Future<void> presentStore({required String appStoreId}) async {
    try {
      await _channel.invokeMethod('presentStore', {'id': appStoreId});
    } catch (e) {
      // Fallback: channel not available or iOS version not supported.
      // Caller can fallback to opening URL.
      rethrow;
    }
  }
}
