import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'author_model.freezed.dart';
part 'author_model.g.dart';

@freezed
abstract class AuthorModel with _$AuthorModel {
  const factory AuthorModel({
    required int id,
    required String firstName,
    required String lastName,
    required String photo,
    required String title,
    String? middleName,
  }) = _AuthorModel;

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);
}

extension AuthorModelX on AuthorModel {
  Author toDomain() => Author(
    id: id,
    firstName: firstName,
    lastName: lastName,
    photo: photo,
    title: title,
    middleName: middleName,
  );
}
