import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'news_item_view_model.freezed.dart';

@freezed
abstract class NewsItemViewModel with _$NewsItemViewModel {
  const factory NewsItemViewModel({
    required NewsItem newsItem,
    Uint8List? coverImage,
  }) = _NewsItemViewModel;
}
