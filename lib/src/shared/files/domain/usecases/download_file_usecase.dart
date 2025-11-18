import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../../../core/base_types/result.dart';

import '../../../../core/value_objects/system_type.dart';
import '../../../../core/value_objects/tcc_image_destination_type.dart';
import '../repositories/file_repository.dart';

class DownloadFileUsecase {
  final FileRepository fileRepository;

  DownloadFileUsecase(this.fileRepository);

  Future<Result<Uint8List>> call({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  }) async {
    return await fileRepository.downloadFile(
      systemType: systemType,
      download: download,
      idFile: idFile,
      uriFile: uriFile,
      urlFile: urlFile,
      imageDestination: imageDestination,
      destinationId: destinationId,
      onProgress: onProgress,
    );
  }
}
