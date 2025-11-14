import 'package:freezed_annotation/freezed_annotation.dart';

import 'resell_item_model.dart';

part 'resell_list_response_model.freezed.dart';
part 'resell_list_response_model.g.dart';

@freezed
abstract class ResellListResponseModel with _$ResellListResponseModel {
  const ResellListResponseModel._();

  const factory ResellListResponseModel({
    required List<ResellItemModel> items,
    required int total,
  }) = _ResellListResponseModel;

  factory ResellListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResellListResponseModelFromJson(json);
}
