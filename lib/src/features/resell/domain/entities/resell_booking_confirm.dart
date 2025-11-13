import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain.dart';

part 'resell_booking_confirm.freezed.dart';

@freezed
abstract class ResellBookingConfirm with _$ResellBookingConfirm {
  const factory ResellBookingConfirm({
    required String id,
    required ApplicationStatus applicationStatus,
    required SystemStatus status,
    String? instance,
    String? bookedUser,
    DateTime? finishDateReservation,
    required bool bookingFinish,
  }) = _ResellBookingConfirm;
}
