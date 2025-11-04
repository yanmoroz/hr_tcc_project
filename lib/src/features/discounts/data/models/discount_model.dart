import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/domain.dart';
import 'author_model.dart';
import 'category_model.dart';

part 'discount_model.freezed.dart';
part 'discount_model.g.dart';

@freezed
abstract class DiscountModel with _$DiscountModel {
  const factory DiscountModel({
    required int id,
    required String title,
    String? shortDescription,
    String? image,
    DateTime? createDate,
    DateTime? dateFrom,
    DateTime? dateTo,
    required AuthorModel author,
    @JsonKey(name: 'category') CategoryModel? categoryModel,
    required int likeCount,
    required bool like,
    required int commentCount,
  }) = _DiscountModel;

  factory DiscountModel.fromJson(Map<String, dynamic> json) => _$DiscountModelFromJson(json);
}

extension DiscountModelX on DiscountModel {
  Discount toDomain() => Discount(
    id: id,
    title: title,
    shortDescription: shortDescription,
    image: image,
    createDate: createDate,
    dateFrom: dateFrom,
    dateTo: dateTo,
    author: author.toDomain(),
    category: categoryModel?.toDomain(),
    likeCount: likeCount,
    like: like,
    commentCount: commentCount,
  );
}
