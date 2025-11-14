import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/features/applications/domain/domain.dart';
import 'package:hr_tcc_project/src/shared/master_data/data/data.dart';

import '../../../../core/data/models/system_status_model.dart';

part 'application_detail_model.freezed.dart';
part 'application_detail_model.g.dart';

@freezed
sealed class ApplicationDetailModel with _$ApplicationDetailModel {
  const ApplicationDetailModel._();

  @JsonSerializable()
  const factory ApplicationDetailModel.alpinaDigitalAccess({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    @JsonKey(name: 'systemStatus') required SystemStatusModel systemStatusModel,
    required DateTime desiredStartDate,
    required String comment,
    @JsonKey(name: 'alpinaDigitalPrevAccess')
    required AlpinaDigitalPrevAccessModel alpinaDigitalPrevAccessModel,
    required bool agreementAcceptance,
  }) = AlpinaDigitalAccessModel;

  @JsonSerializable()
  const factory ApplicationDetailModel.courierDelivery({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    @JsonKey(name: 'systemStatus') required SystemStatusModel systemStatusModel,
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
  }) = CourierDeliveryModel;

  @JsonSerializable()
  const factory ApplicationDetailModel.businessTrip({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    @JsonKey(name: 'systemStatus') required SystemStatusModel systemStatusModel,
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
  }) = BusinessTripModel;

  @JsonSerializable()
  const factory ApplicationDetailModel.referralProgram({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    @JsonKey(name: 'systemStatus') required SystemStatusModel systemStatusModel,
  }) = ReferralProgramModel;

  @JsonSerializable()
  const factory ApplicationDetailModel.unplannedTraining({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    @JsonKey(name: 'systemStatus') required SystemStatusModel systemStatusModel,
  }) = UnplannedTrainingModel;

  @JsonSerializable()
  const factory ApplicationDetailModel.violation({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    @JsonKey(name: 'systemStatus') required SystemStatusModel systemStatusModel,
  }) = ViolationModel;

  @JsonSerializable()
  const factory ApplicationDetailModel.absence({
    required String id,
    required String applicationFormCode,
    required DateTime applicationDate,
    @JsonKey(name: 'systemStatus') required SystemStatusModel systemStatusModel,
  }) = AbsenceModel;

  factory ApplicationDetailModel.fromJson(Map<String, dynamic> json) {
    final formCode = json['applicationFormCode'] as String;

    switch (formCode) {
      case 'alpinaAccess':
        return _$AlpinaDigitalAccessModelFromJson(json);
      case 'courierDelivery':
        return _$CourierDeliveryModelFromJson(json);
      case 'businessTrip':
        return _$BusinessTripModelFromJson(json);
      case 'referralProgram':
        return _$ReferralProgramModelFromJson(json);
      case 'unplannedTraining':
        return _$UnplannedTrainingModelFromJson(json);
      case 'violation':
        return _$ViolationModelFromJson(json);
      case 'absence':
        return _$AbsenceModelFromJson(json);
      default:
        throw Exception('Unknown application form code: $formCode');
    }
  }

  ApplicationDetail toDomain() {
    return map(
      alpinaDigitalAccess: (model) => ApplicationDetail.alpinaDigitalAccess(
        id: model.id,
        applicationFormCode: model.applicationFormCode,
        applicationDate: model.applicationDate,
        systemStatus: model.systemStatusModel.toDomain(),
        desiredStartDate: model.desiredStartDate,
        comment: model.comment,
        alpinaDigitalPrevAccess: model.alpinaDigitalPrevAccessModel.toDomain(),
        agreementAcceptance: model.agreementAcceptance,
      ),
      courierDelivery: (model) => ApplicationDetail.courierDelivery(
        id: model.id,
        applicationFormCode: model.applicationFormCode,
        applicationDate: model.applicationDate,
        systemStatus: model.systemStatusModel.toDomain(),
        deliveryType: model.deliveryType,
        deliveryAddress: model.deliveryAddress,
        deliveryDate: model.deliveryDate,
        legalEntity: model.legalEntity,
        office: model.office,
        recepientCompanyName: model.recepientCompanyName,
        recepientNameContact: model.recepientNameContact,
        recepientPhoneNumber: model.recepientPhoneNumber,
        tripPurpose: model.tripPurpose,
        urgency: model.urgency,
        recepientEmail: model.recepientEmail,
        comments: model.comments,
        choiceExplanation: model.choiceExplanation,
        contentDescription: model.contentDescription,
      ),
      businessTrip: (model) => ApplicationDetail.businessTrip(
        id: model.id,
        applicationFormCode: model.applicationFormCode,
        applicationDate: model.applicationDate,
        systemStatus: model.systemStatusModel.toDomain(),
        activityType: model.activityType,
        country: model.country,
        startDate: model.startDate,
        endDate: model.endDate,
        departure: model.departure,
        destination: model.destination,
        travelers: model.travelers,
        financeDivisionTripCode: model.financeDivisionTripCode,
        financeDivisionTripString: model.financeDivisionTripString,
        tripPurposeId: model.tripPurposeId,
        tripPurposeString: model.tripPurposeString,
        plannedEvents: model.plannedEvents,
        urgency: model.urgency,
        selectionHelpTripCode: model.selectionHelpTripCode,
        comment: model.comment,
        files: model.files,
        legalEntity: model.legalEntity,
      ),
      referralProgram: (model) => ApplicationDetail.referralProgram(
        id: model.id,
        applicationFormCode: model.applicationFormCode,
        applicationDate: model.applicationDate,
        systemStatus: model.systemStatusModel.toDomain(),
      ),
      unplannedTraining: (model) => ApplicationDetail.unplannedTraining(
        id: model.id,
        applicationFormCode: model.applicationFormCode,
        applicationDate: model.applicationDate,
        systemStatus: model.systemStatusModel.toDomain(),
      ),
      violation: (model) => ApplicationDetail.violation(
        id: model.id,
        applicationFormCode: model.applicationFormCode,
        applicationDate: model.applicationDate,
        systemStatus: model.systemStatusModel.toDomain(),
      ),
      absence: (model) => ApplicationDetail.absence(
        id: model.id,
        applicationFormCode: model.applicationFormCode,
        applicationDate: model.applicationDate,
        systemStatus: model.systemStatusModel.toDomain(),
      ),
    );
  }
}
