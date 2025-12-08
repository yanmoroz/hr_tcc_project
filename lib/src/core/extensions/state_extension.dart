import 'package:flutter/material.dart';

extension StateExtension on State {
  void safeSetState(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(callback); // ignore: invalid_use_of_protected_member
      }
    });
  }
}
