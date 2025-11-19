import 'package:freezed_annotation/freezed_annotation.dart';

import 'news_item_model.dart';

part 'news_list_response_model.freezed.dart';
part 'news_list_response_model.g.dart';

@freezed
abstract class NewsListResponseModel with _$NewsListResponseModel {
  const factory NewsListResponseModel({
    required List<NewsItemModel> items,
    required int total,
  }) = _NewsListResponseModel;

  factory NewsListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NewsListResponseModelFromJson(json);
}
