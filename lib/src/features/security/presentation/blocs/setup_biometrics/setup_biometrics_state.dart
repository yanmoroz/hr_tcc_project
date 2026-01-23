import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/entities/security_settings.dart';

part 'setup_biometrics_state.freezed.dart';

@freezed
sealed class SetupBiometricsState with _$SetupBiometricsState {
  const factory SetupBiometricsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(BiometricsType.none) BiometricsType availableType,
    @Default(false) bool isEnabled,
    @Default(false) bool isSkipped,
    String? errorMessage,
  }) = _SetupBiometricsState;
}
