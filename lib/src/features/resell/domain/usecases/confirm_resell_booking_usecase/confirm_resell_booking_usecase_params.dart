import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain.dart';

part 'confirm_resell_booking_usecase_params.freezed.dart';

@freezed
abstract class ConfirmResellBookingUsecaseParams
    with _$ConfirmResellBookingUsecaseParams {
  const factory ConfirmResellBookingUsecaseParams({
    required String id,
    required BookingTransition transition,
    String? inn,
    String? address,
    String? employeePlace,
    bool? pickupLotMyself,
  }) = _ResellBookingConfirmation;
}
