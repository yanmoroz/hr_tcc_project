import 'package:freezed_annotation/freezed_annotation.dart';

part 'resell_booking_confirmation_model.freezed.dart';
part 'resell_booking_confirmation_model.g.dart';

@freezed
abstract class ResellBookingConfirmationModel
    with _$ResellBookingConfirmationModel {
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
