import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/entities/security_settings.dart';

part 'verify_pincode_state.freezed.dart';

@freezed
sealed class VerifyPincodeState with _$VerifyPincodeState {
  const factory VerifyPincodeState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default('') String enteredPincode,
    @Default(0) int attempts,
    @Default(3) int maxAttempts,
    String? errorMessage,
    @Default(false) bool isVerified,
    @Default(false) bool isBiometricsAvailable,
    @Default(false) bool isBiometricsEnabled,
    @Default(BiometricsType.none) BiometricsType biometricsType,
  }) = _VerifyPincodeState;
}
