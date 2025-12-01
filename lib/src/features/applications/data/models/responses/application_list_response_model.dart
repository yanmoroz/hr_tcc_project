import 'package:freezed_annotation/freezed_annotation.dart';

import 'application_info_model.dart';
import 'application_statistics_model.dart';

part 'application_list_response_model.freezed.dart';
part 'application_list_response_model.g.dart';

@freezed
abstract class ApplicationListResponseModel
    with _$ApplicationListResponseModel {
  const factory ApplicationListResponseModel({
    required List<ApplicationInfoModel> applicationInfos,
    required int total,
    required List<ApplicationStatisticsModel>? statistics,
  }) = _ApplicationListResponseModel;

  factory ApplicationListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationListResponseModelFromJson(json);
}
