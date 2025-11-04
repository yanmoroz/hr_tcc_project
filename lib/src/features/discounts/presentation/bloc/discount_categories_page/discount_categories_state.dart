import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../shared/master_data/domain/domain.dart';

part 'discount_categories_state.freezed.dart';

@freezed
class DiscountCategoriesState with _$DiscountCategoriesState {
  const factory DiscountCategoriesState.initial() = DiscountCategoriesInitial;
  const factory DiscountCategoriesState.loading() = DiscountCategoriesLoading;
  const factory DiscountCategoriesState.loaded({
    required List<KpDiscountCategory> categories,
    required List<KpDiscountSource> sources,
  }) = DiscountCategoriesLoaded;
  const factory DiscountCategoriesState.error(String message) = DiscountCategoriesError;
}
