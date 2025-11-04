import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/domain.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({required int id, required String title, required int discounts}) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
}

extension CategoryModelX on CategoryModel {
  Category toDomain() => Category(id: id, title: title, discounts: discounts);
}
