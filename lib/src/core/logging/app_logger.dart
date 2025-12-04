import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static Logger? _logger;

  static Logger get instance {
    _logger ??= Logger(
      printer: PrettyPrinter(
        methodCount: 0, // Stack trace method count
        errorMethodCount: 8, // Stack trace method count for errors
        lineLength: 120,
        colors: !kReleaseMode,
        printEmojis: !kReleaseMode,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: kReleaseMode ? Level.warning : Level.debug,
    );
    return _logger!;
  }

  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.d(message, error: error, stackTrace: stackTrace);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.e(message, error: error, stackTrace: stackTrace);
  }

  static void f(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.f(message, error: error, stackTrace: stackTrace);
  }

  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.i(message, error: error, stackTrace: stackTrace);
  }

  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.w(message, error: error, stackTrace: stackTrace);
  }
}
