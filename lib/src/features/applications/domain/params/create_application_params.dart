import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_application_params.freezed.dart';

/// Domain-layer parameters for creating applications
/// Sealed class covering all application types without depending on data layer
@freezed
sealed class CreateApplicationParams with _$CreateApplicationParams {
  /// Alpina Digital Access application
  const factory CreateApplicationParams.alpinaDigitalAccess({
    required String desiredStartDate,
    String? comment,
    required String alpinaDigitalPrevAccessCode,
    required bool agreementAcceptance,
  }) = AlpinaDigitalAccessParams;

  /// Courier Delivery application
  const factory CreateApplicationParams.courierDelivery({
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
  }) = CourierDeliveryParams;

  /// Unplanned Training application
  const factory CreateApplicationParams.unplannedTraining({
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
  }) = UnplannedTrainingParams;

  /// Referral Program application
  const factory CreateApplicationParams.referralProgram({
    required String idVacancy,
    required CandidateInfo fullName,
    String? resumeFile,
    String? linkToResume,
    String? comment,
  }) = ReferralProgramParams;

  /// Violation application
  const factory CreateApplicationParams.violation({
    required String securityLevelId,
    required String summary,
    required String description,
  }) = ViolationParams;

  /// Absence application
  const factory CreateApplicationParams.absence({
    required int category,
    required String note,
    String? fromDateTime,
    String? toDateTime,
  }) = AbsenceParams;

  /// Business Trip application
  const factory CreateApplicationParams.businessTrip({
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
  }) = BusinessTripParams;
}

/// Candidate information for referral program (domain entity)
@freezed
abstract class CandidateInfo with _$CandidateInfo {
  const factory CandidateInfo({
    required String lastName,
    required String firstName,
    String? middleName,
  }) = _CandidateInfo;
}
