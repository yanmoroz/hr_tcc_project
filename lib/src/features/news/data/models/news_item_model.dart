import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';
import 'author_model.dart';
import 'kp_news_category_model.dart';

part 'news_item_model.freezed.dart';
part 'news_item_model.g.dart';

@freezed
abstract class NewsItemModel with _$NewsItemModel {
  const factory NewsItemModel({
    required int id,
    required String title,
    required String summary,
    required DateTime createdData,
    required bool published,
    required double priority,
    @JsonKey(name: 'category') required KpNewsCategoryModel category,
    required AuthorModel author,
    required int likeCount,
    required bool like,
    required int commentCount,
    String? image,
  }) = _NewsItemModel;

  factory NewsItemModel.fromJson(Map<String, dynamic> json) =>
      _$NewsItemModelFromJson(json);
}

extension NewsItemModelX on NewsItemModel {
  NewsItem toDomain() => NewsItem(
    id: id,
    title: title,
    summary: summary,
    createdData: createdData,
    published: published,
    priority: priority,
    categoryCode: category.code,
    categoryName: category.name,
    author: author.toDomain(),
    likeCount: likeCount,
    like: like,
    commentCount: commentCount,
    image: image,
  );
}
