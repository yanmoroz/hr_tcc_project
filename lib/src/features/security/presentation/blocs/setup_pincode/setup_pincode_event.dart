import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup_pincode_event.freezed.dart';

@freezed
class SetupPincodeEvent with _$SetupPincodeEvent {
  const factory SetupPincodeEvent.digitEntered(String digit) = DigitEntered;

  const factory SetupPincodeEvent.digitDeleted() = DigitDeleted;

  const factory SetupPincodeEvent.pincodeEntered() = PincodeEntered;

  const factory SetupPincodeEvent.pincodeConfirmed() = PincodeConfirmed;

  const factory SetupPincodeEvent.reset() = Reset;
}
