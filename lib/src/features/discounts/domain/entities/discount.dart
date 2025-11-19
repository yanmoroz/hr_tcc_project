import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';
import 'category.dart';

part 'discount.freezed.dart';

@freezed
abstract class Discount with _$Discount {
  const factory Discount({
    required int id,
    required String title,
    String? shortDescription,
    String? image,
    DateTime? createDate,
    DateTime? dateFrom,
    DateTime? dateTo,
    required Author author,
    Category? category,
    required int likeCount,
    required bool like,
    required int commentCount,
  }) = _Discount;
}
