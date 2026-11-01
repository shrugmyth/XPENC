import 'dart:io';

import 'package:flutter/foundation.dart';

/// What the platform this build runs on can actually do — one place for the
/// Android-only features, so a screen hides an entry instead of each feature
/// failing on its own with a `MissingPluginException`.
///
/// iOS is the only platform with gaps today. Each one is a missing native
/// half, not a Dart limitation: home-screen widgets need a WidgetKit
/// extension, share-to-XPENC a Share extension, OCR a Vision-based plugin,
/// and the rest are things iOS simply doesn't offer an app.
abstract final class PlatformFeatures {
  /// Pretends to be (or not to be) iOS — for tests, which run on the host OS.
  @visibleForTesting
  static bool? debugIsIOS;

  static bool get isIOS => debugIsIOS ?? (!kIsWeb && Platform.isIOS);

  /// Pretends to be (or not to be) Android — for tests. When only
  /// [debugIsIOS] is set, Android is "whatever iOS isn't", so the existing
  /// iOS tests keep meaning what they always did.
  @visibleForTesting
  static bool? debugIsAndroid;

  /// The Android-only features below are gated on this rather than on
  /// "not iOS", so a desktop build (macOS) gets them switched off too.
  ///
  /// Widget tests run on the host OS (macOS/Linux) but have always been
  /// written against the Android feature set, so under `flutter test` the
  /// default stays "Android unless told it's iOS".
  static bool get isAndroid =>
      debugIsAndroid ??
      (debugIsIOS != null || _underFlutterTest
          ? !isIOS
          : (!kIsWeb && Platform.isAndroid));

  static final bool _underFlutterTest =
      !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  /// Home-screen widgets (Android's AppWidgets — see `HomeWidgetService`).
  static bool get homeWidgets => isAndroid;

  /// Picking XPENC from another app's Share sheet (see `ShareIntakeService`).
  static bool get shareIntake => isAndroid;

  /// On-device text recognition — the Tesseract plugin is Android-only.
  static bool get ocr => isAndroid;

  /// The standing quick-add notification. iOS has no ongoing notifications,
  /// and its reply action would need a notification category plus a
  /// background isolate wired up natively.
  static bool get quickAddNotification => isAndroid;

  /// Blocking screenshots and screen recording. iOS lets an app detect a
  /// screenshot after the fact, never prevent one.
  static bool get screenshotBlocking => isAndroid;

  /// Settings › Permissions. iOS manages every grant from its own Settings
  /// app, and the native half of `AppPermissions` is Android-only.
  static bool get permissionsScreen => isAndroid;

  /// Backups in the public `Download/BACKUP XPENC` folder, which outlives an
  /// uninstall. iOS has no shared folder an app may write to unasked, so
  /// there backups live in the app's own storage instead — see
  /// `BackupService`.
  static bool get durableBackupFolder => isAndroid;

  /// Picking from the device address book — `flutter_contacts` has no
  /// desktop implementation.
  static bool get contactImport => isAndroid || isIOS;

  /// Taking a photo with the camera — `image_picker` has no camera source
  /// on desktop; picking an existing file still works everywhere.
  static bool get cameraCapture => isAndroid || isIOS;
}
