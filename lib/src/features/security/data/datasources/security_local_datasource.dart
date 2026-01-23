import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/entities/security_settings.dart';

abstract class SecurityLocalDataSource {
  Future<void> storePincodeHash(String hash);
  Future<String?> getPincodeHash();
  Future<void> setBiometricsEnabled(bool enabled);
  Future<bool> isBiometricsEnabled();
  Future<bool> isPincodeSet();
  Future<BiometricsType> getAvailableBiometrics();
  Future<bool> authenticateWithBiometrics();
  Future<void> clearAll();
}

class SecurityLocalDataSourceImpl implements SecurityLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;

  static const _pincodeHashKey = 'pincode_hash';
  static const _biometricsEnabledKey = 'biometrics_enabled';

  SecurityLocalDataSourceImpl(this._secureStorage, this._localAuth);

  @override
  Future<void> storePincodeHash(String hash) async {
    await _secureStorage.write(key: _pincodeHashKey, value: hash);
  }

  @override
  Future<String?> getPincodeHash() async {
    return _secureStorage.read(key: _pincodeHashKey);
  }

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _biometricsEnabledKey,
      value: enabled.toString(),
    );
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    final value = await _secureStorage.read(key: _biometricsEnabledKey);
    return value == 'true';
  }

  @override
  Future<bool> isPincodeSet() async {
    final hash = await _secureStorage.read(key: _pincodeHashKey);
    return hash != null && hash.isNotEmpty;
  }

  @override
  Future<BiometricsType> getAvailableBiometrics() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();

    if (!canCheck || !isDeviceSupported) return BiometricsType.none;

    final availableBiometrics = await _localAuth.getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.face)) {
      return BiometricsType.faceId;
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return BiometricsType.fingerprint;
    } else if (availableBiometrics.contains(BiometricType.strong)) {
      return BiometricsType.fingerprint;
    }
    return BiometricsType.none;
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    return _localAuth.authenticate(
      localizedReason: 'Подтвердите вход с помощью биометрии',
    );
  }

  @override
  Future<void> clearAll() async {
    await _secureStorage.delete(key: _pincodeHashKey);
    await _secureStorage.delete(key: _biometricsEnabledKey);
  }
}
