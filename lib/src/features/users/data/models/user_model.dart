import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String title,
    String? position,
    String? idPersonElma,
    int? idPersonKp,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  User toDomain() => User(
    id: id,
    title: title,
    position: position,
    idPersonElma: idPersonElma,
    idPersonKp: idPersonKp,
  );
}
