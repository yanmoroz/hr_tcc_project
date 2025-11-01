import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/data/base_repository.dart';
import '../../../../core/exceptions/network/network_exception.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/data_sources.dart';
import '../models/uploaded_file_model.dart';

class FileRepositoryImpl with BaseRepository implements FileRepository {
  final FileRemoteDataSource _remoteDataSource;

  FileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, UploadedFile>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    ProgressCallback? onProgress,
  }) async {
    final result = await _remoteDataSource.uploadFile(
      file: file,
      systemType: systemType,
      group: group,
      issueIdOrKey: issueIdOrKey,
      onProgress: onProgress,
    );

    return mapResult(result, (model) => model.toDomain());
  }

  @override
  Future<Either<NetworkException, Uint8List>> downloadFile({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    ProgressCallback? onProgress,
  }) async {
    return await _remoteDataSource.downloadFile(
      systemType: systemType,
      download: download,
      idFile: idFile,
      uriFile: uriFile,
      urlFile: urlFile,
      onProgress: onProgress,
    );
  }
}
