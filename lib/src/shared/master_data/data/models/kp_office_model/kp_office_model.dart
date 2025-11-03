import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'kp_office_model.freezed.dart';
part 'kp_office_model.g.dart';

@freezed
abstract class KpOfficeModel with _$KpOfficeModel {
  const factory KpOfficeModel({required int id, required String name}) = _KpOfficeModel;

  factory KpOfficeModel.fromJson(Map<String, dynamic> json) => _$KpOfficeModelFromJson(json);
}

extension KpOfficeModelX on KpOfficeModel {
  KpOffice toDomain() {
    return KpOffice(id: id, name: name);
  }
}
