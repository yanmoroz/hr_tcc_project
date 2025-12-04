import 'package:flutter/foundation.dart';

class RetryNotifier extends ChangeNotifier {
  void notifyRetry() {
    notifyListeners();
  }
}
