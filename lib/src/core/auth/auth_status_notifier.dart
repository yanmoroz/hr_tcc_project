import 'package:flutter/foundation.dart';

import 'auth_token_provider.dart';

/// Authentication status for multi-step auth flow.
enum AuthStatus {
  /// No tokens - show login
  unauthenticated,

  /// Has tokens, no pincode - show pincode setup
  needsPincodeSetup,

  /// Has tokens, pincode set - show unlock screen
  needsUnlock,

  /// Fully authenticated - show home
  authenticated,
}

/// Provides reactive auth status for GoRouter's refreshListenable.
/// This is a lightweight ChangeNotifier that tracks authentication state
/// including pincode/biometrics setup status.
class AuthStatusNotifier extends ChangeNotifier {
  final AuthTokenProvider _tokenProvider;
  AuthStatus _status = AuthStatus.unauthenticated;

  Future<bool> Function()? _isPincodeSetChecker;

  AuthStatusNotifier(this._tokenProvider);

  AuthStatus get status => _status;

  /// Legacy getter for backward compatibility
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  bool get needsUnlock => _status == AuthStatus.needsUnlock;

  bool get needsPincodeSetup => _status == AuthStatus.needsPincodeSetup;

  /// Configure security checkers (called from DI after SecurityRepository is ready).
  void configureSecurityCheckers({
    required Future<bool> Function() isPincodeSet,
  }) {
    _isPincodeSetChecker = isPincodeSet;
  }

  /// Initialize auth status from stored tokens and security settings.
  /// Call this during app startup after AuthTokenProvider is initialized.
  Future<void> checkInitialStatus() async {
    final hasToken = await _tokenProvider.hasToken();

    if (!hasToken) {
      _status = AuthStatus.unauthenticated;
      return;
    }

    final isPincodeSet = await _isPincodeSetChecker?.call() ?? false;

    if (!isPincodeSet) {
      _status = AuthStatus.needsPincodeSetup;
    } else {
      _status = AuthStatus.needsUnlock;
    }
  }

  /// Call after successful login - user needs to setup pincode.
  void notifyLoggedIn() {
    _status = AuthStatus.needsPincodeSetup;
    notifyListeners();
  }

  /// Call after pincode setup complete.
  void notifyPincodeSetupComplete() {
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  /// Call after biometrics setup complete (or skipped).
  void notifyBiometricsSetupComplete() {
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  /// Call after successful unlock (pincode or biometrics).
  void notifyUnlocked() {
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  /// Call after logout - clears everything.
  void notifyLoggedOut() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Call when app resumes from background (to require unlock again).
  Future<void> notifyNeedsUnlock() async {
    final hasToken = await _tokenProvider.hasToken();
    final isPincodeSet = await _isPincodeSetChecker?.call() ?? false;

    if (hasToken && isPincodeSet) {
      _status = AuthStatus.needsUnlock;
      notifyListeners();
    }
  }
}
