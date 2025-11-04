import 'package:freezed_annotation/freezed_annotation.dart';
import 'author.dart';
import 'category.dart';
import 'source.dart';
import 'organisation.dart';

part 'discount_detail.freezed.dart';

@freezed
abstract class DiscountDetail with _$DiscountDetail {
  const factory DiscountDetail({
    required int id,
    required String title,
    String? description,
    String? shortDescription,
    String? image,
    DateTime? createDate,
    DateTime? dateFrom,
    DateTime? dateTo,
    required Author author,
    Category? category,
    Source? discountSource,
    String? contact,
    String? phone,
    String? email,
    String? site,
    String? address,
    String? promocode,
    String? notificationText,
    List<Organisation>? organisations,
    int? notifyItemsCount,
  }) = _DiscountDetail;
}
