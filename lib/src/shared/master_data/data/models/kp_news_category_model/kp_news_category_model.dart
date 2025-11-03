import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'kp_news_category_model.freezed.dart';
part 'kp_news_category_model.g.dart';

@freezed
abstract class KpNewsCategoryModel with _$KpNewsCategoryModel {
  const factory KpNewsCategoryModel({required int code, required String name}) = _KpNewsCategoryModel;

  factory KpNewsCategoryModel.fromJson(Map<String, dynamic> json) => _$KpNewsCategoryModelFromJson(json);
}

extension KpNewsCategoryModelX on KpNewsCategoryModel {
  KpNewsCategory toDomain() {
    return KpNewsCategory(code: code, name: name);
  }
}
