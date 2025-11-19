import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'organisation_model.freezed.dart';
part 'organisation_model.g.dart';

@freezed
abstract class OrganisationModel with _$OrganisationModel {
  const factory OrganisationModel({required int id, required String title}) =
      _OrganisationModel;

  factory OrganisationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganisationModelFromJson(json);
}

extension OrganisationModelX on OrganisationModel {
  Organisation toDomain() => Organisation(id: id, title: title);
}
