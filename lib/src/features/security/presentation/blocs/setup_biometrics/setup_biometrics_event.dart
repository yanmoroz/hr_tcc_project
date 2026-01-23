import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup_biometrics_event.freezed.dart';

@freezed
class SetupBiometricsEvent with _$SetupBiometricsEvent {
  const factory SetupBiometricsEvent.checkAvailability() = CheckAvailability;

  const factory SetupBiometricsEvent.enableBiometrics() = EnableBiometrics;

  const factory SetupBiometricsEvent.skip() = Skip;
}
