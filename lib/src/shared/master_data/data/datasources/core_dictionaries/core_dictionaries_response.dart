import '../../models/models.dart';

class CoreDictionariesResponse {
  final List<ApplicationFormGroupModel> applicationFormGroups;
  final List<ApplicationFormModel> applicationForms;
  final List<SystemStatusGroupModel> systemStatusesGroups;
  final List<SystemStatusModel> systemStatuses;
  final List<TripPurposeModel> tripPurposes;
  final List<TrainingTypeModel> trainingTypes;
  final List<TrainingFormModel> trainingForms;
  final List<TrainingMonthModel> trainingMonths;
  final List<AlpinaDigitalPrevAccessModel> alpinaDigitalPrevAccesses;
  final List<OfficeModel> offices;

  CoreDictionariesResponse({
    required this.applicationFormGroups,
    required this.applicationForms,
    required this.systemStatusesGroups,
    required this.systemStatuses,
    required this.tripPurposes,
    required this.trainingTypes,
    required this.trainingForms,
    required this.trainingMonths,
    required this.alpinaDigitalPrevAccesses,
    required this.offices,
  });
}
