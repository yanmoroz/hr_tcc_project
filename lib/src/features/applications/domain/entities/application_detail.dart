import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/alpina_digital_prev_access.dart';
import '../../../../core/entities/system_status.dart';

part 'application_detail.freezed.dart';

@freezed
sealed class ApplicationDetail with _$ApplicationDetail {
  const factory ApplicationDetail.alpinaDigitalAccess({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    required SystemStatus systemStatus,
    required DateTime desiredStartDate,
    String? comment,
    required AlpinaDigitalPrevAccess alpinaDigitalPrevAccess,
    required bool agreementAcceptance,
  }) = AlpinaDigitalAccessDetail;

  const factory ApplicationDetail.courierDelivery({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    required SystemStatus systemStatus,
    required bool deliveryType,
    required String deliveryAddress,
    required DateTime deliveryDate,
    required String legalEntity,
    required String office,
    required String recepientCompanyName,
    required String recepientNameContact,
    required String recepientPhoneNumber,
    required String tripPurpose,
    required bool urgency,
    String? recepientEmail,
    String? comments,
    String? choiceExplanation,
    String? contentDescription,
  }) = CourierDeliveryDetail;

  const factory ApplicationDetail.businessTrip({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    required SystemStatus systemStatus,
    required bool activityType,
    required String country,
    required DateTime startDate,
    required DateTime endDate,
    required String departure,
    required String destination,
    required List<String> travelers,
    String? financeDivisionTripCode,
    String? financeDivisionTripString,
    String? tripPurposeId,
    String? tripPurposeString,
    String? plannedEvents,
    String? urgency,
    String? selectionHelpTripCode,
    String? comment,
    List<String>? files,
    String? legalEntity,
  }) = BusinessTripDetail;

  const factory ApplicationDetail.referralProgram({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    required SystemStatus systemStatus,
  }) = ReferralProgramDetail;

  const factory ApplicationDetail.unplannedTraining({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    required SystemStatus systemStatus,
  }) = UnplannedTrainingDetail;

  const factory ApplicationDetail.violation({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    required SystemStatus systemStatus,
  }) = ViolationDetail;

  const factory ApplicationDetail.absence({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    required SystemStatus systemStatus,
  }) = AbsenceDetail;
}
