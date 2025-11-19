import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/booking_transition.dart';

part 'confirm_resell_booking_params.freezed.dart';

@freezed
abstract class ConfirmResellBookingParams with _$ConfirmResellBookingParams {
  const factory ConfirmResellBookingParams({
    required String id,
    required BookingTransition transition,
    String? inn,
    String? address,
    String? employeePlace,
    bool? pickupLotMyself,
  }) = _ResellBookingConfirmation;
}
