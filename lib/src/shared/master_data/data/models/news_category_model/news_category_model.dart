import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'news_category_model.freezed.dart';
part 'news_category_model.g.dart';

@freezed
abstract class NewsCategoryModel with _$NewsCategoryModel {
  const factory NewsCategoryModel({required int code, required String name}) = _NewsCategoryModel;

  factory NewsCategoryModel.fromJson(Map<String, dynamic> json) => _$NewsCategoryModelFromJson(json);
}

extension NewsCategoryModelX on NewsCategoryModel {
  NewsCategory toDomain() {
    return NewsCategory(code: code, name: name);
  }
}
