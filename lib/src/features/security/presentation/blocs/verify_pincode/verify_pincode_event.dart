import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_pincode_event.freezed.dart';

@freezed
class VerifyPincodeEvent with _$VerifyPincodeEvent {
  const factory VerifyPincodeEvent.digitEntered(String digit) = VerifyDigitEntered;

  const factory VerifyPincodeEvent.digitDeleted() = VerifyDigitDeleted;

  const factory VerifyPincodeEvent.verify() = Verify;

  const factory VerifyPincodeEvent.checkBiometrics() = CheckBiometrics;

  const factory VerifyPincodeEvent.authenticateWithBiometrics() =
      AuthenticateWithBiometrics;

  const factory VerifyPincodeEvent.reset() = VerifyReset;
}
