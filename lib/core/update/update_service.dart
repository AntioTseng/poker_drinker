import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'ios_store.dart' as ios_store;

class UpdateService {
  /// For Android: check Play Core for available updates and try immediate update.
  static Future<void> checkAndPerformAndroidInAppUpdate() async {
    if (!Platform.isAndroid) return;

    // Ensure we log local package version for debugging
    await logLocalVersion();

    try {
      final info = await InAppUpdate.checkForUpdate();
      debugPrint(
        'InAppUpdate info: updateAvailability=${info.updateAvailability}',
      );

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        // Try immediate update first; if it fails, try flexible as fallback.
        try {
          await InAppUpdate.performImmediateUpdate();
        } catch (e) {
          debugPrint('Immediate update failed: $e');
          try {
            await InAppUpdate.startFlexibleUpdate();
          } catch (e2) {
            debugPrint('Flexible update failed: $e2');
          }
        }
      }
    } catch (e) {
      debugPrint('In-app update check failed: $e');
    }
  }

  /// Logs local package version (used for debugging/QA)
  static Future<void> logLocalVersion() async {
    try {
      final p = await PackageInfo.fromPlatform();
      debugPrint('Local app version: ${p.version}+${p.buildNumber}');
    } catch (e) {
      debugPrint('Failed to read package info: $e');
    }
  }

  /// Open the store listing for the given packageId / appId.
  /// For Android: provide package name (e.g. com.example.app)
  /// For iOS: provide numeric App Store id (e.g. 123456789)
  static Future<void> openStoreListing({required String id}) async {
    final uri = Platform.isAndroid
        ? Uri.parse('https://play.google.com/store/apps/details?id=$id')
        : Uri.parse('https://apps.apple.com/app/id$id');
    if (Platform.isIOS) {
      try {
        await ios_store.IOSStore.presentStore(appStoreId: id);
        return;
      } catch (_) {
        // fallback to opening URL
      }
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch store URL: $uri');
    }
  }
}
