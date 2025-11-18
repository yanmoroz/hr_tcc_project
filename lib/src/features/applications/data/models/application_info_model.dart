import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/features/applications/domain/domain.dart';

import '../../../../core/dictionaries/data/models/models.dart';

part 'application_info_model.freezed.dart';
part 'application_info_model.g.dart';

@freezed
abstract class ApplicationInfoModel with _$ApplicationInfoModel {
  const ApplicationInfoModel._();

  const factory ApplicationInfoModel({
    required String id,
    required String idApplication,
    required String name,
    required ApplicationFormModel applicationForm,
    required String iniciator,
    required SystemStatusModel systemStatus,
    required DateTime applicationDate,
    required DateTime createDate,
  }) = _ApplicationInfoModel;

  factory ApplicationInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationInfoModelFromJson(json);

  ApplicationInfo toDomain() => ApplicationInfo(
    id: id,
    idApplication: idApplication,
    name: name,
    applicationForm: applicationForm.toDomain(),
    iniciator: iniciator,
    systemStatus: systemStatus.toDomain(),
    applicationDate: applicationDate,
    createDate: createDate,
  );
}
