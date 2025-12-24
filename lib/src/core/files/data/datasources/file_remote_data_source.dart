import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../base_types/result.dart';
import '../../../value_objects/system_type.dart';
import '../../../value_objects/tcc_image_destination_type.dart';
import '../../value_objects/file_group.dart';
import '../models/uploaded_file_model.dart';

abstract class FileRemoteDataSource {
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

  Future<Result<UploadedFileModel>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  });
}
