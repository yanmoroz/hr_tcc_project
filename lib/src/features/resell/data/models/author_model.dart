import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'author_model.freezed.dart';
part 'author_model.g.dart';

@freezed
abstract class AuthorModel with _$AuthorModel {
  const AuthorModel._();

  const factory AuthorModel({
    required String id,
    required String lastName,
    required String firstName,
    String? middleName,
  }) = _AuthorModel;

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);

  Author toDomain() => Author(
    id: id,
    lastName: lastName,
    firstName: firstName,
    middleName: middleName,
  );
}
