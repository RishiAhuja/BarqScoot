// Create a new file: lib/utils/logger.dart
import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String message, {String tag = 'ESCOOTER'}) {
    if (kDebugMode) {
      debugPrint('[${tag}_LOG] $message');
    }
  }

  static void error(String message,
      {Object? error, StackTrace? stackTrace, String tag = 'ESCOOTER'}) {
    if (kDebugMode) {
      final errorMsg = error != null ? ' | Error: $error' : '';
      final stackMsg = stackTrace != null ? ' | Stack: $stackTrace' : '';

      debugPrint('❌ [${tag}_ERROR] ❌ [$tag] $message$errorMsg$stackMsg');
    }
  }
}
