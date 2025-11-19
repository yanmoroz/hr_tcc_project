import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';
import 'department_model.dart';

part 'author_model.freezed.dart';
part 'author_model.g.dart';

@freezed
abstract class AuthorModel with _$AuthorModel {
  const factory AuthorModel({
    List<String>? workplaces,
    String? email,
    String? phoneMain,
    String? phoneAdd,
    String? phoneMob,
    String? phonePers,
    String? sip,
    required String firstName,
    required String lastName,
    String? patronymic,
    String? position,
    DepartmentModel? department,
    String? organisation,
    bool? archive,
    int? vacationDaysLeft,
    bool? isVaccinated,
    String? status,
    required String photo,
    required int id,
    required String title,
  }) = _AuthorModel;

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);
}

extension AuthorModelX on AuthorModel {
  Author toDomain() => Author(
    workplaces: workplaces,
    email: email,
    phoneMain: phoneMain,
    phoneAdd: phoneAdd,
    phoneMob: phoneMob,
    phonePers: phonePers,
    sip: sip,
    firstName: firstName,
    lastName: lastName,
    patronymic: patronymic,
    position: position,
    department: department?.toDomain(),
    organisation: organisation,
    archive: archive,
    vacationDaysLeft: vacationDaysLeft,
    isVaccinated: isVaccinated,
    status: status,
    photo: photo,
    id: id,
    title: title,
  );
}
