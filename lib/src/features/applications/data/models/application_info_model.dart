import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/features/applications/domain/domain.dart';
import 'package:hr_tcc_project/src/shared/master_data/data/data.dart';

part 'application_info_model.freezed.dart';
part 'application_info_model.g.dart';

@freezed
abstract class ApplicationInfoModel with _$ApplicationInfoModel {
  const ApplicationInfoModel._();

  const factory ApplicationInfoModel({
    required String id,
    required String idApplication,
    required String name,
    @JsonKey(name: 'applicationForm') required ApplicationFormModel applicationFormModel,
    required String iniciator,
    @JsonKey(name: 'systemStatus') required SystemStatusModel systemStatusModel,
    required DateTime applicationDate,
    required DateTime createDate,
  }) = _ApplicationInfoModel;

  factory ApplicationInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationInfoModelFromJson(json);

  ApplicationInfo toDomain() => ApplicationInfo(
        id: id,
        idApplication: idApplication,
        name: name,
        applicationForm: applicationFormModel.toDomain(),
        iniciator: iniciator,
        systemStatus: systemStatusModel.toDomain(),
        applicationDate: applicationDate,
        createDate: createDate,
      );
}
