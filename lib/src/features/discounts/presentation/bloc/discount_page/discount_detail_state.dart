import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'discount_detail_state.freezed.dart';

@freezed
class DiscountDetailState with _$DiscountDetailState {
  const factory DiscountDetailState.initial() = DiscountDetailInitial;
  const factory DiscountDetailState.loading() = DiscountDetailLoading;
  const factory DiscountDetailState.loaded({
    required DiscountDetail discount,
    required int likeCount,
    required bool liked,
    required int commentCount,
    Uint8List? coverImage,
  }) = DiscountDetailLoaded;
  const factory DiscountDetailState.error(String message) = DiscountDetailError;
}
