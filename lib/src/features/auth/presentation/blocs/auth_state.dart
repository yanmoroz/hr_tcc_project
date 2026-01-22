import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/base_types/loading_status.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(false) bool isAuthenticated,
    String? errorMessage,
  }) = _AuthState;
}
