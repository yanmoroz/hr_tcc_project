import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'tcc_upload_file_response_model.freezed.dart';
part 'tcc_upload_file_response_model.g.dart';

/// TCC system upload response model
@freezed
abstract class TccUploadFileResponseModel with _$TccUploadFileResponseModel {
  const factory TccUploadFileResponseModel({required String id, required int size, required String systemType}) =
      _TccUploadFileResponseModel;

  factory TccUploadFileResponseModel.fromJson(Map<String, dynamic> json) => _$TccUploadFileResponseModelFromJson(json);
}

extension TccUploadFileResponseModelX on TccUploadFileResponseModel {
  UploadedFile toDomain() {
    return UploadedFile.tcc(id: id, size: size);
  }
}
