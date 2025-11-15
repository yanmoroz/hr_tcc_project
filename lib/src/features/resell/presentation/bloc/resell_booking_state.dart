import 'package:freezed_annotation/freezed_annotation.dart';

part 'resell_booking_state.freezed.dart';

@freezed
class ResellBookingState with _$ResellBookingState {
  const factory ResellBookingState.initial() = ResellBookingInitial;
  const factory ResellBookingState.confirmingBooking() =
      ResellBookingConfirming;
  const factory ResellBookingState.bookingConfirmed() = ResellBookingConfirmed;
  const factory ResellBookingState.error(String message) = ResellBookingError;
}
