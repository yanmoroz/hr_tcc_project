import 'package:fpdart/fpdart.dart';

import '../../../../core/base_types/result.dart';
import '../entities/security_settings.dart';

abstract class SecurityRepository {
  Future<Result<Unit>> setupPincode(String pincode);

  Future<Result<bool>> verifyPincode(String pincode);

  Future<Result<Unit>> setBiometricsEnabled(bool enabled);

  Future<Result<BiometricsType>> checkBiometricsAvailability();

  Future<Result<bool>> authenticateWithBiometrics();

  Future<Result<SecuritySettings>> getSecuritySettings();

  Future<Result<Unit>> clearSecuritySettings();

  Future<bool> isPincodeSet();

  Future<bool> isBiometricsEnabled();
}
