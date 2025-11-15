import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../../../core/base_types/result.dart';

import '../entities/entities.dart';
import '../repositories/repositories.dart';

class DownloadFileUsecase {
  final FileRepository fileRepository;

  DownloadFileUsecase(this.fileRepository);

  Future<Result<Uint8List>> call({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    ProgressCallback? onProgress,
  }) async {
    return await fileRepository.downloadFile(
      systemType: systemType,
      download: download,
      idFile: idFile,
      uriFile: uriFile,
      urlFile: urlFile,
      onProgress: onProgress,
    );
  }
}
