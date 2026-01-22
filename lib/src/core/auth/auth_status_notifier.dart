import 'package:flutter/foundation.dart';

import 'auth_token_provider.dart';

/// Provides reactive auth status for GoRouter's refreshListenable.
/// This is a lightweight ChangeNotifier that only tracks whether the user
/// is authenticated, without managing loading/error states (which belong in UI).
class AuthStatusNotifier extends ChangeNotifier {
  final AuthTokenProvider _tokenProvider;
  bool _isAuthenticated = false;

  AuthStatusNotifier(this._tokenProvider);

  bool get isAuthenticated => _isAuthenticated;

  /// Initialize auth status from stored tokens.
  /// Call this during app startup after AuthTokenProvider is initialized.
  Future<void> checkInitialStatus() async {
    _isAuthenticated = await _tokenProvider.hasToken();
  }

  /// Call after successful login to update auth status and trigger navigation.
  void notifyLoggedIn() {
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Call after logout to update auth status and trigger navigation.
  void notifyLoggedOut() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
