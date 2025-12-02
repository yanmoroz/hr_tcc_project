import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'organization_model.freezed.dart';
part 'organization_model.g.dart';

@freezed
abstract class OrganizationModel with _$OrganizationModel {
  const factory OrganizationModel({
    String? id,
    String? code,
    String? name,
    String? fullName,
  }) = _OrganizationModel;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);
}

extension OrganizationModelX on OrganizationModel {
  Organization toDomain() =>
      Organization(id: id, code: code, name: name, fullName: fullName);
}
