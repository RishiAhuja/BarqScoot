import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    level: Level.debug,
  );

  static void log(String message, {String tag = 'ESCOOTER'}) {
    _logger.i('[$tag] $message');
  }

  static void debug(String message, {String tag = 'ESCOOTER'}) {
    _logger.d('[$tag] $message');
  }

  static void error(String message,
      {Object? error, StackTrace? stackTrace, String tag = 'ESCOOTER'}) {
    _logger.e(
      '[$tag] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void warning(String message, {String tag = 'ESCOOTER'}) {
    _logger.w('[$tag] $message');
  }

  static void verbose(String message, {String tag = 'ESCOOTER'}) {
    _logger.v('[$tag] $message');
  }

  static void wtf(String message,
      {Object? error, StackTrace? stackTrace, String tag = 'ESCOOTER'}) {
    _logger.wtf(
      '[$tag] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
