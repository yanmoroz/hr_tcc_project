import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/base_types/result.dart';
import '../../../../core/value_objects/system_type.dart';
import '../../../../core/value_objects/tcc_image_destination_type.dart';
import '../domain.dart';

abstract class FileRepository {
  Future<void> cleanupExpiredCache();

  Future<Result<Uint8List>> downloadFile({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  });

  Future<Result<UploadedFile>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  });
}
