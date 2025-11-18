import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../core/base_types/result.dart';

import '../../../../core/value_objects/system_type.dart';
import '../../../../core/value_objects/tcc_image_destination_type.dart';
import '../domain.dart';

class UploadFileUsecase {
  final FileRepository fileRepository;

  UploadFileUsecase(this.fileRepository);

  Future<Result<UploadedFile>> call({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  }) async {
    return await fileRepository.uploadFile(
      file: file,
      systemType: systemType,
      group: group,
      issueIdOrKey: issueIdOrKey,
      imageDestination: imageDestination,
      destinationId: destinationId,
      onProgress: onProgress,
    );
  }
}
