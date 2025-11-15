import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/master_data/models/system_status_model.dart';

part 'resell_booking_confirm_model.freezed.dart';
part 'resell_booking_confirm_model.g.dart';

@freezed
abstract class ResellBookingConfirmModel with _$ResellBookingConfirmModel {
  const ResellBookingConfirmModel._();

  const factory ResellBookingConfirmModel({
    required String id,
    required String applicationStatus,
    required SystemStatusModel status,
    String? instance,
    String? bookedUser,
    DateTime? finishDateReservation,
    required bool bookingFinish,
  }) = _ResellBookingConfirmModel;

  factory ResellBookingConfirmModel.fromJson(Map<String, dynamic> json) =>
      _$ResellBookingConfirmModelFromJson(json);
}
