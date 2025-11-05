import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'news_detail_state.freezed.dart';

@freezed
class NewsDetailState with _$NewsDetailState {
  const factory NewsDetailState.initial() = NewsDetailInitial;
  const factory NewsDetailState.loading() = NewsDetailLoading;
  const factory NewsDetailState.loaded({
    required NewsDetail newsDetail,
    required int likeCount,
    required bool liked,
    required int commentCount,
    Uint8List? coverImage,
  }) = NewsDetailLoaded;
  const factory NewsDetailState.error(String message) = NewsDetailError;
}
