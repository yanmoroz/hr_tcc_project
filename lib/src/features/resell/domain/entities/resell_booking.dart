import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain.dart';

part 'resell_booking.freezed.dart';

@freezed
abstract class ResellBooking with _$ResellBooking {
  const factory ResellBooking({
    required String id,
    required ApplicationStatus applicationStatus,
    required SystemStatus status,
    String? instance,
    String? bookedUser,
    DateTime? finishDateReservation,
    bool? bookingFinish,
  }) = _ResellBooking;
}
