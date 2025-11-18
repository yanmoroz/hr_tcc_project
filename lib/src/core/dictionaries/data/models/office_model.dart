import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entities/office.dart';

part 'office_model.freezed.dart';
part 'office_model.g.dart';

@freezed
abstract class OfficeModel with _$OfficeModel {
  const factory OfficeModel({
    required String id,
    required String code,
    required String name,
  }) = _OfficeModel;

  factory OfficeModel.fromJson(Map<String, dynamic> json) =>
      _$OfficeModelFromJson(json);
}

extension OfficeModelX on OfficeModel {
  Office toDomain() {
    return Office(id: id, code: code, name: name);
  }
}
