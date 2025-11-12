import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';

part 'resell_booking_confirmation_model.freezed.dart';
part 'resell_booking_confirmation_model.g.dart';

@freezed
abstract class ResellBookingConfirmationModel with _$ResellBookingConfirmationModel {
  const ResellBookingConfirmationModel._();

  const factory ResellBookingConfirmationModel({
    required int transition,
    String? inn,
    String? address,
    String? employeePlace,
    bool? pickupLotMyself,
  }) = _ResellBookingConfirmationModel;

  factory ResellBookingConfirmationModel.fromJson(Map<String, dynamic> json) =>
      _$ResellBookingConfirmationModelFromJson(json);
}

extension ResellBookingConfirmationModelX on ResellBookingConfirmationModel {
  ResellBookingConfirmation toDomain() => ResellBookingConfirmation(
    transition: transition == 0 ? BookingTransition.cancel : BookingTransition.confirm,
    inn: inn,
    address: address,
    employeePlace: employeePlace,
    pickupLotMyself: pickupLotMyself,
  );
}

extension ResellBookingConfirmationX on ResellBookingConfirmation {
  ResellBookingConfirmationModel toModel() => ResellBookingConfirmationModel(
    transition: transition.value,
    inn: inn,
    address: address,
    employeePlace: employeePlace,
    pickupLotMyself: pickupLotMyself,
  );
}
