import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization.freezed.dart';

@freezed
abstract class Organization with _$Organization {
  const factory Organization({
    String? id,
    String? code,
    String? name,
    String? fullName,
  }) = _Organization;
}
