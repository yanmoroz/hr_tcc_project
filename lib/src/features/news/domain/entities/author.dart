import 'package:freezed_annotation/freezed_annotation.dart';

part 'author.freezed.dart';

@freezed
abstract class Author with _$Author {
  const factory Author({
    required int id,
    required String firstName,
    required String lastName,
    required String photo,
    required String title,
    String? middleName,
  }) = _Author;
}
