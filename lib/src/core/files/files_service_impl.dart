import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../base_types/result.dart';
import '../value_objects/system_type.dart';
import '../value_objects/tcc_image_destination_type.dart';
import 'data/datasources/file_local_data_source.dart';
import 'data/datasources/file_remote_data_source.dart';
import 'data/models/uploaded_file_model.dart';
import 'entities/uploaded_file.dart';
import 'files_service.dart';
import 'value_objects/file_group.dart';

/// Implementation of [FilesService] that orchestrates remote and local data sources.
///
/// Downloads are cached locally using [FileLocalDataSource].
/// Uploads are passed directly to [FileRemoteDataSource].
class FilesServiceImpl implements FilesService {
  final FileRemoteDataSource _remoteDataSource;
  final FileLocalDataSource _localDataSource;

  FilesServiceImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<void> cleanupExpiredCache() async {
    await _localDataSource.cleanupExpired();
  }

  @override
  Future<Result<Uint8List>> downloadFile({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  }) async {
    // Generate cache key based on file identifiers
    final cacheKey = _localDataSource.generateCacheKey(
      systemType: systemType,
      download: download,
      idFile: idFile,
      uriFile: uriFile,
      urlFile: urlFile,
      imageDestination: imageDestination,
      destinationId: destinationId,
    );

    // Try to load from cache first
    final cachedData = await _localDataSource.getCached(cacheKey);
    if (cachedData != null) {
      return Right(cachedData);
    }

    // Download from remote if not in cache
    final result = await _remoteDataSource.downloadFile(
      systemType: systemType,
      download: download,
      idFile: idFile,
      uriFile: uriFile,
      urlFile: urlFile,
      imageDestination: imageDestination,
      destinationId: destinationId,
      onProgress: onProgress,
    );

    // Save to cache if download was successful and has content
    await result.fold(
      (error) {
        // Don't cache errors
      },
      (data) async {
        if (data.isNotEmpty) {
          await _localDataSource.cache(cacheKey, data);
        }
      },
    );

    return result;
  }

  @override
  Future<Result<UploadedFile>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  }) async {
    final result = await _remoteDataSource.uploadFile(
      file: file,
      systemType: systemType,
      group: group,
      issueIdOrKey: issueIdOrKey,
      imageDestination: imageDestination,
      destinationId: destinationId,
      onProgress: onProgress,
    );

    return result.map((model) => model.toDomain());
  }
}
