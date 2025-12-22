import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'news_item.freezed.dart';

@freezed
abstract class NewsItem with _$NewsItem {
  const factory NewsItem({
    required int id,
    required String title,
    String? summary,
    required DateTime createdData,
    required bool published,
    required double priority,
    int? categoryCode,
    String? categoryName,
    required Author author,
    required int likeCount,
    required bool like,
    required int commentCount,
    String? image,
  }) = _NewsItem;
}
