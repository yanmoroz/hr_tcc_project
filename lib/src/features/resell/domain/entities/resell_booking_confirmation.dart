import 'package:freezed_annotation/freezed_annotation.dart';

import 'booking_transition.dart';

part 'resell_booking_confirmation.freezed.dart';

@freezed
abstract class ResellBookingConfirmation with _$ResellBookingConfirmation {
  const factory ResellBookingConfirmation({
    required BookingTransition transition,
    String? inn,
    String? address,
    String? employeePlace,
    bool? pickupLotMyself,
  }) = _ResellBookingConfirmation;
}
