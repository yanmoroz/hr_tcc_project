import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/network/network_exception.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class DownloadFileUsecase {
  final FileRepository fileRepository;

  DownloadFileUsecase(this.fileRepository);

  Future<Either<NetworkException, Uint8List>> call({
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
