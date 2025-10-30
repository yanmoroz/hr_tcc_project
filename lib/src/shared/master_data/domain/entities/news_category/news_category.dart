import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_category.freezed.dart';

@freezed
abstract class NewsCategory with _$NewsCategory {
  const factory NewsCategory({required int code, required String name}) = _NewsCategory;
}
