import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'discount_categories_state.freezed.dart';

@freezed
sealed class DiscountCategoriesState with _$DiscountCategoriesState {
  const factory DiscountCategoriesState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<KpDiscountCategory> categories,
    @Default([]) List<KpDiscountSource> sources,
    String? errorMessage,
  }) = _DiscountCategoriesState;
}
