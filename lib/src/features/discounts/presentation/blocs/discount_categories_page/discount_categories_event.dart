import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount_categories_event.freezed.dart';

@freezed
class DiscountCategoriesEvent with _$DiscountCategoriesEvent {
  const factory DiscountCategoriesEvent.loadCategories() = LoadCategories;
  const factory DiscountCategoriesEvent.refreshCategories() = RefreshCategories;
}
