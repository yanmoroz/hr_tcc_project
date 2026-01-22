import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String title,
    String? position,
    String? idPersonElma,
    int? idPersonKp,
  }) = _User;
}
