import 'package:freezed_annotation/freezed_annotation.dart';

part 'author.freezed.dart';

@freezed
abstract class Author with _$Author {
  const factory Author({
    required String id,
    required String lastName,
    required String firstName,
    String? middleName,
  }) = _Author;
}
