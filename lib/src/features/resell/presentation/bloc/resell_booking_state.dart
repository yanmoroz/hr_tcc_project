import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';

part 'resell_booking_state.freezed.dart';

@freezed
class ResellBookingState with _$ResellBookingState {
  const factory ResellBookingState.initial(ResellBooking booking) = ResellBookingInitial;
  const factory ResellBookingState.confirmingBooking() = ResellBookingConfirming;
  const factory ResellBookingState.bookingConfirmed(ResellBookingConfirm booking) = ResellBookingConfirmed;
  const factory ResellBookingState.error(String message) = ResellBookingError;
}
