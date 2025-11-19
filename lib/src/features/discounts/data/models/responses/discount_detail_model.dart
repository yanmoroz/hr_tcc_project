import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';
import 'author_model.dart';
import 'category_model.dart';
import 'source_model.dart';
import 'organisation_model.dart';

part 'discount_detail_model.freezed.dart';
part 'discount_detail_model.g.dart';

@freezed
abstract class DiscountDetailModel with _$DiscountDetailModel {
  const factory DiscountDetailModel({
    required int id,
    required String title,
    String? description,
    String? shortDescription,
    String? image,
    DateTime? createDate,
    DateTime? dateFrom,
    DateTime? dateTo,
    required AuthorModel author,
    @JsonKey(name: 'category') CategoryModel? categoryModel,
    @JsonKey(name: 'discountSource') SourceModel? discountSourceModel,
    String? contact,
    String? phone,
    String? email,
    String? site,
    String? address,
    String? promocode,
    String? notificationText,
    List<OrganisationModel>? organisations,
    int? notifyItemsCount,
  }) = _DiscountDetailModel;

  factory DiscountDetailModel.fromJson(Map<String, dynamic> json) =>
      _$DiscountDetailModelFromJson(json);
}

extension DiscountDetailModelX on DiscountDetailModel {
  DiscountDetail toDomain() => DiscountDetail(
    id: id,
    title: title,
    description: description,
    shortDescription: shortDescription,
    image: image,
    createDate: createDate,
    dateFrom: dateFrom,
    dateTo: dateTo,
    author: author.toDomain(),
    category: categoryModel?.toDomain(),
    discountSource: discountSourceModel?.toDomain(),
    contact: contact,
    phone: phone,
    email: email,
    site: site,
    address: address,
    promocode: promocode,
    notificationText: notificationText,
    organisations: organisations?.map((o) => o.toDomain()).toList(),
    notifyItemsCount: notifyItemsCount,
  );
}
