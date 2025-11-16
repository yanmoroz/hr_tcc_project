import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../core/base_types/result.dart';

import '../../../../core/value_objects/system_type.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class UploadFileUsecase {
  final FileRepository fileRepository;

  UploadFileUsecase(this.fileRepository);

  Future<Result<UploadedFile>> call({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    ProgressCallback? onProgress,
  }) async {
    return await fileRepository.uploadFile(
      file: file,
      systemType: systemType,
      group: group,
      issueIdOrKey: issueIdOrKey,
      onProgress: onProgress,
    );
  }
}
