import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'alpina_digital_prev_access_model.freezed.dart';
part 'alpina_digital_prev_access_model.g.dart';

@freezed
abstract class AlpinaDigitalPrevAccessModel with _$AlpinaDigitalPrevAccessModel {
  const factory AlpinaDigitalPrevAccessModel({required String id, required String code, required String name}) =
      _AlpinaDigitalPrevAccessModel;

  factory AlpinaDigitalPrevAccessModel.fromJson(Map<String, dynamic> json) =>
      _$AlpinaDigitalPrevAccessModelFromJson(json);
}

extension AlpinaDigitalPrevAccessModelX on AlpinaDigitalPrevAccessModel {
  AlpinaDigitalPrevAccess toDomain() {
    return AlpinaDigitalPrevAccess(id: id, code: code, name: name);
  }
}
