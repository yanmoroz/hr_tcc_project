import 'package:flutter/foundation.dart';

/// A notifier that broadcasts retry events to listeners.
///
/// Used to decouple widgets from global retry logic.
/// When a retry action occurs (e.g., NetworkErrorMessageWidget retry button),
/// listeners at the app shell level can react accordingly.
class RetryNotifier extends ChangeNotifier {
  void notifyRetry() {
    notifyListeners();
  }
}
