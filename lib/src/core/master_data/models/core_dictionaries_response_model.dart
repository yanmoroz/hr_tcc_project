import 'package:freezed_annotation/freezed_annotation.dart';

import 'alpina_digital_prev_access_model.dart';
import 'application_form_group_model.dart';
import 'application_form_model.dart';
import 'office_model.dart';
import 'system_status_group_model.dart';
import 'system_status_model.dart';
import 'training_form_model.dart';
import 'training_month_model.dart';
import 'training_type_model.dart';
import 'trip_purpose_model.dart';

part 'core_dictionaries_response_model.freezed.dart';
part 'core_dictionaries_response_model.g.dart';

@freezed
abstract class CoreDictionariesResponseModel
    with _$CoreDictionariesResponseModel {
  const factory CoreDictionariesResponseModel({
    required List<ApplicationFormGroupModel> applicationFormGroups,
    required List<ApplicationFormModel> applicationForms,
    required List<SystemStatusGroupModel> systemStatusesGroups,
    required List<SystemStatusModel> systemStatuses,
    required List<TripPurposeModel> tripPurposes,
    required List<TrainingTypeModel> trainingTypes,
    required List<TrainingFormModel> trainingForms,
    required List<TrainingMonthModel> trainingMonths,
    required List<AlpinaDigitalPrevAccessModel> alpinaDigitalPrevAccesses,
    @JsonKey(name: 'dictOffices') required List<OfficeModel> offices,
  }) = _CoreDictionariesResponseModel;

  factory CoreDictionariesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CoreDictionariesResponseModelFromJson(json);
}
