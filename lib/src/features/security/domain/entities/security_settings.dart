import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_settings.freezed.dart';

enum BiometricsType {
  fingerprint,
  faceId,
  none,
}

@freezed
abstract class SecuritySettings with _$SecuritySettings {
  const factory SecuritySettings({
    required bool isPincodeSet,
    required bool isBiometricsEnabled,
    required BiometricsType availableBiometrics,
  }) = _SecuritySettings;
}
