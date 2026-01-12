import 'package:freezed_annotation/freezed_annotation.dart';

part 'resell_booking_event.freezed.dart';

@freezed
abstract class ResellBookingEvent with _$ResellBookingEvent {
  const factory ResellBookingEvent.cancelBooking(String itemId) = CancelBooking;
  const factory ResellBookingEvent.confirmBooking({
    String? inn,
    String? address,
    String? employeePlace,
    required bool pickupLotMyself,
  }) = ConfirmBooking;
}
