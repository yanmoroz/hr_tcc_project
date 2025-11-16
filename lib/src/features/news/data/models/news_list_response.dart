import 'package:freezed_annotation/freezed_annotation.dart';

import 'news_item_model.dart';

part 'news_list_response.freezed.dart';
part 'news_list_response.g.dart';

@freezed
abstract class NewsListResponse with _$NewsListResponse {
  const factory NewsListResponse({
    required List<NewsItemModel> items,
    required int total,
  }) = _NewsListResponse;

  factory NewsListResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsListResponseFromJson(json);
}
