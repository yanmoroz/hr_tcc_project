import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized application logger utility.
///
/// Provides structured logging with different levels (debug, info, warning, error).
/// Automatically configures logging level based on build mode (debug/production).
class AppLogger {
  static Logger? _logger;

  /// Get the logger instance.
  /// Creates a new instance if one doesn't exist.
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

  /// Log a debug message.
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log an info message.
  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message.
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log an error message.
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a fatal error message.
  static void f(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.f(message, error: error, stackTrace: stackTrace);
  }
}
