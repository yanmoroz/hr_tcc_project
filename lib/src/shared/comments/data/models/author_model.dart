import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'author_model.freezed.dart';
part 'author_model.g.dart';

@freezed
abstract class AuthorModel with _$AuthorModel {
  const factory AuthorModel({
    required String firstName,
    String? lastName,
    String? middleName,
    String? position,
    String? organisation,
    required bool isArchive,
    required int vacationDaysLeft,
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
    firstName: firstName,
    lastName: lastName,
    middleName: middleName,
    position: position,
    organisation: organisation,
    isArchive: isArchive,
    vacationDaysLeft: vacationDaysLeft,
    status: status,
    photo: photo,
    id: id,
    title: title,
  );
}
