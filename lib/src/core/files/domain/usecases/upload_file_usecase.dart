import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/network/network_exception.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class UploadFileUsecase {
  final FileRepository fileRepository;

  UploadFileUsecase(this.fileRepository);

  Future<Either<NetworkException, UploadedFile>> call({
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
