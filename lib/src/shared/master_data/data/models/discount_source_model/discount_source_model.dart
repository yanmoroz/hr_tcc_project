import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'discount_source_model.freezed.dart';
part 'discount_source_model.g.dart';

@freezed
abstract class DiscountSourceModel with _$DiscountSourceModel {
  const factory DiscountSourceModel({required int code, required String name}) = _DiscountSourceModel;

  factory DiscountSourceModel.fromJson(Map<String, dynamic> json) => _$DiscountSourceModelFromJson(json);
}

extension DiscountSourceModelX on DiscountSourceModel {
  DiscountSource toDomain() {
    return DiscountSource(code: code, name: name);
  }
}
