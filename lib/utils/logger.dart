// Create a new file: lib/utils/logger.dart
import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String message, {String tag = 'ESCOOTER'}) {
    if (kDebugMode) {
      debugPrint(''); // Add an empty line before
      debugPrint('=== $tag ===');
      debugPrint(message);
      debugPrint('============');
      debugPrint(''); // Add an empty line after
    }
  }

  static void error(String message,
      {Object? error, StackTrace? stackTrace, String tag = 'ESCOOTER'}) {
    if (kDebugMode) {
      debugPrint('');
      debugPrint('❌ ERROR ❌');
      debugPrint(message);
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('Stack: $stackTrace');
      debugPrint('=====$tag=====');
      debugPrint('');
    }
  }
}
