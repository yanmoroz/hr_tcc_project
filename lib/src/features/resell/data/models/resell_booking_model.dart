import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/master_data/data/data.dart';
import '../../domain/domain.dart';

part 'resell_booking_model.freezed.dart';
part 'resell_booking_model.g.dart';

@freezed
abstract class ResellBookingModel with _$ResellBookingModel {
  const ResellBookingModel._();

  const factory ResellBookingModel({
    required String id,
    required String applicationStatus,
    @JsonKey(name: 'status') required SystemStatusModel statusModel,
    String? instance,
    String? bookedUser,
    DateTime? finishDateReservation,
    bool? bookingFinish,
  }) = _ResellBookingModel;

  factory ResellBookingModel.fromJson(Map<String, dynamic> json) => _$ResellBookingModelFromJson(json);

  ResellBooking toDomain() => ResellBooking(
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
