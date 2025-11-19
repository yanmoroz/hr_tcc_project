import 'package:freezed_annotation/freezed_annotation.dart';

import 'candidate_info_model.dart';

part 'create_application_request_model.freezed.dart';
part 'create_application_request_model.g.dart';

/// Abstract base class for all application creation requests
/// Mirrors Java's AbstractCreateApplicationRequest with polymorphic JSON serialization
@Freezed(unionKey: 'applicationFormCode', unionValueCase: FreezedUnionCase.none)
sealed class CreateApplicationRequestModel
    with _$CreateApplicationRequestModel {
  /// Alpina Digital Access request - alpinaAccess
  const factory CreateApplicationRequestModel.alpinaAccess({
    required String desiredStartDate,
    String? comment,
    required String alpinaDigitalPrevAccessCode,
    required bool agreementAcceptance,
  }) = AlpinaDigitalAccessRequestModel;

  /// Courier Delivery request - courierDelivery
  const factory CreateApplicationRequestModel.courierDelivery({
    required bool deliveryType,
    required String tripPurposesCode,
    required String office,
    required String deliveryDate,
    required bool urgency,
    required String recepientCompanyName,
    required String deliveryAddress,
    required String recepientNameContact,
    required String recepientPhoneNumber,
    String? recepientEmail,
    String? comments,
    String? choiceExplanation,
    String? contentDescription,
  }) = CourierDeliveryRequestModel;

  /// Unplanned Training request - unplannedTraining
  const factory CreateApplicationRequestModel.unplannedTraining({
    required String supervisorEmployee,
    required String chief,
    String? contractor,
    required bool notListOrganizers,
    String? organizer,
    required String eventTitle,
    required String trainingTypeCode,
    required String trainingFormCode,
    String? startDateTraining,
    String? endDateTraining,
    required bool exactDatesUnknown,
    String? trainingMonthCode,
    required int costInt,
    required String purposeTraining,
    required String linkCourse,
    required String employee,
    List<String>? groupEmployees,
  }) = UnplannedTrainingRequestModel;

  /// Referral Program request - referralProgram
  const factory CreateApplicationRequestModel.referralProgram({
    required String idVacancy,
    required CandidateInfoModel fullName,
    String? resumeFile,
    String? linkToResume,
    String? comment,
  }) = ReferralProgramRequestModel;

  /// Violation request - violation
  const factory CreateApplicationRequestModel.violation({
    required String securityLevelId,
    required String summary,
    required String description,
  }) = ViolationRequestModel;

  /// Absence request - absence
  const factory CreateApplicationRequestModel.absence({
    required int category,
    required String note,
    String? fromDateTime,
    String? toDateTime,
  }) = AbsenceRequestModel;

  /// Business Trip request - businessTrip
  const factory CreateApplicationRequestModel.businessTrip({
    required String startDate,
    required String endDate,
    required String departure,
    required String destination,
    required String financeDivisionTripCode,
    String? financeDivisionTripString,
    required String tripPurposeId,
    String? tripPurposeString,
    @Default(true) bool activityType,
    String? plannedEvents,
    String? urgency,
    required String selectionHelpTripCode,
    String? comment,
    List<String>? files,
    required List<String> travelers,
    required String country,
    String? legalEntity,
  }) = BusinessTripRequestModel;

  factory CreateApplicationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateApplicationRequestModelFromJson(json);
}
