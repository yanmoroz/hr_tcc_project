import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'news_detail_state.freezed.dart';

@freezed
sealed class NewsDetailState with _$NewsDetailState {
  const factory NewsDetailState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    NewsDetail? newsDetail,
    @Default(0) int likeCount,
    @Default(false) bool liked,
    @Default(0) int commentCount,
    Uint8List? coverImage,
    String? errorMessage,
  }) = _NewsDetailState;
}
