import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/base_types/result.dart';
import '../../domain/entities/security_settings.dart';
import '../../domain/repositories/security_repository.dart';
import '../datasources/security_local_datasource.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  final SecurityLocalDataSource _localDataSource;

  SecurityRepositoryImpl(this._localDataSource);

  String _hashPincode(String pincode) {
    const salt = 'hr_tcc_security_salt';
    final bytes = utf8.encode('$salt$pincode');
    return sha256.convert(bytes).toString();
  }

  @override
  Future<Result<Unit>> setupPincode(String pincode) async {
    try {
      final hash = _hashPincode(pincode);
      await _localDataSource.storePincodeHash(hash);
      return const Right(unit);
    } catch (e) {
      return Left(Exception('Failed to setup pincode: $e'));
    }
  }

  @override
  Future<Result<bool>> verifyPincode(String pincode) async {
    try {
      final storedHash = await _localDataSource.getPincodeHash();
      if (storedHash == null) {
        return const Right(false);
      }
      final inputHash = _hashPincode(pincode);
      return Right(storedHash == inputHash);
    } catch (e) {
      return Left(Exception('Failed to verify pincode: $e'));
    }
  }

  @override
  Future<Result<Unit>> setBiometricsEnabled(bool enabled) async {
    try {
      await _localDataSource.setBiometricsEnabled(enabled);
      return const Right(unit);
    } catch (e) {
      return Left(Exception('Failed to set biometrics: $e'));
    }
  }

  @override
  Future<Result<BiometricsType>> checkBiometricsAvailability() async {
    try {
      final type = await _localDataSource.getAvailableBiometrics();
      return Right(type);
    } catch (e) {
      return Left(Exception('Failed to check biometrics: $e'));
    }
  }

  @override
  Future<Result<bool>> authenticateWithBiometrics() async {
    try {
      final result = await _localDataSource.authenticateWithBiometrics();
      return Right(result);
    } catch (e) {
      return Left(Exception('Biometric authentication failed: $e'));
    }
  }

  @override
  Future<Result<SecuritySettings>> getSecuritySettings() async {
    try {
      final isPincode = await _localDataSource.isPincodeSet();
      final isBiometrics = await _localDataSource.isBiometricsEnabled();
      final biometricsType = await _localDataSource.getAvailableBiometrics();

      return Right(
        SecuritySettings(
          isPincodeSet: isPincode,
          isBiometricsEnabled: isBiometrics,
          availableBiometrics: biometricsType,
        ),
      );
    } catch (e) {
      return Left(Exception('Failed to get security settings: $e'));
    }
  }

  @override
  Future<Result<Unit>> clearSecuritySettings() async {
    try {
      await _localDataSource.clearAll();
      return const Right(unit);
    } catch (e) {
      return Left(Exception('Failed to clear security settings: $e'));
    }
  }

  @override
  Future<bool> isPincodeSet() => _localDataSource.isPincodeSet();

  @override
  Future<bool> isBiometricsEnabled() => _localDataSource.isBiometricsEnabled();
}
