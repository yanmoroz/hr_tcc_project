import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/master_data/data/data.dart';
import '../../domain/domain.dart';

part 'resell_booking_confirm_model.freezed.dart';
part 'resell_booking_confirm_model.g.dart';

@freezed
abstract class ResellBookingConfirmModel with _$ResellBookingConfirmModel {
  const ResellBookingConfirmModel._();

  const factory ResellBookingConfirmModel({
    required String id,
    required String applicationStatus,
    @JsonKey(name: 'status') required SystemStatusModel statusModel,
    String? instance,
    String? bookedUser,
    DateTime? finishDateReservation,
    required bool bookingFinish,
  }) = _ResellBookingConfirmModel;

  factory ResellBookingConfirmModel.fromJson(Map<String, dynamic> json) => _$ResellBookingConfirmModelFromJson(json);

  ResellBookingConfirm toDomain() => ResellBookingConfirm(
    id: id,
    applicationStatus: _parseApplicationStatus(applicationStatus),
    status: statusModel.toDomain(),
    instance: instance,
    bookedUser: bookedUser,
    finishDateReservation: finishDateReservation,
    bookingFinish: bookingFinish,
  );

  ApplicationStatus _parseApplicationStatus(String status) {
    switch (status.toLowerCase()) {
      case 'ok':
        return ApplicationStatus.ok;
      case 'processing':
        return ApplicationStatus.processing;
      default:
        return ApplicationStatus.processing;
    }
  }
}
