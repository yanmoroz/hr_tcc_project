import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';

part 'resell_booking_event.freezed.dart';

@freezed
abstract class ResellBookingEvent with _$ResellBookingEvent {
  const factory ResellBookingEvent.confirmBooking({required ConfirmResellBookingUsecaseParams params}) = ConfirmBooking;
}
