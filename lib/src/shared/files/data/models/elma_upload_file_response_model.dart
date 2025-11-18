import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'elma_upload_file_response_model.freezed.dart';
part 'elma_upload_file_response_model.g.dart';

/// ELMA system upload response model
@freezed
abstract class ElmaUploadFileResponseModel with _$ElmaUploadFileResponseModel {
  const factory ElmaUploadFileResponseModel({
    required String idFile,
    required String systemType,
  }) = _ElmaUploadFileResponseModel;

  factory ElmaUploadFileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ElmaUploadFileResponseModelFromJson(json);
}

extension ElmaUploadFileResponseModelX on ElmaUploadFileResponseModel {
  UploadedFile toDomain() {
    return UploadedFile.elma(idFile: idFile);
  }
}
