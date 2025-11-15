import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../../../core/base_types/result.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';
import 'file_remote_data_source.dart';

class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final ApiClient _apiClient;

  FileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<UploadedFileModel>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    ProgressCallback? onProgress,
  }) async {
    try {
      // Build query parameters
      final queryParameters = <String, dynamic>{'systemType': systemType.value};

      if (group != null && systemType == SystemType.kp) {
        queryParameters['group'] = group.value;
      }

      if (issueIdOrKey != null && systemType == SystemType.jira) {
        queryParameters['issueIdOrKey'] = issueIdOrKey;
      }

      // Create FormData with file
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      // Execute upload
      final result = await ApiCallExecutor.executeApiCall<UploadedFileModel>(
        apiCall: () => _apiClient.uploadFile(
          ApiConstants.filesUploadEndpoint,
          formData: formData,
          queryParameters: queryParameters,
          onSendProgress: onProgress,
        ),
        successParser: (response) {
          final json = response.data as Map<String, dynamic>;
          // Try to parse with automatic systemType detection from JSON (like Java JsonTypeInfo)
          // Fallback to explicit systemType for backward compatibility
          try {
            return UploadedFileModel.fromJson(json);
          } catch (e) {
            // If systemType is not in JSON, use the provided systemType
            return UploadedFileModel.fromJsonWithSystemType(json, systemType);
          }
        },
        validStatusCodes: [200],
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.e('Error uploading file', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Result<Uint8List>> downloadFile({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    ProgressCallback? onProgress,
  }) async {
    try {
      // Build query parameters
      final queryParameters = <String, dynamic>{
        'systemType': systemType.value,
        'download': download,
      };

      // Add file identifier based on system type
      if (idFile != null) {
        queryParameters['idFile'] = idFile;
      }
      if (uriFile != null) {
        queryParameters['uriFile'] = uriFile;
      }
      if (urlFile != null) {
        queryParameters['urlFile'] = urlFile;
      }

      // Execute download
      final result = await ApiCallExecutor.executeApiCall<Uint8List>(
        apiCall: () => _apiClient.downloadFile(
          ApiConstants.filesDownloadEndpoint,
          queryParameters: queryParameters,
          onReceiveProgress: onProgress,
        ),
        successParser: (response) {
          if (response.data is List<int>) {
            return Uint8List.fromList(response.data as List<int>);
          } else if (response.data is Uint8List) {
            return response.data as Uint8List;
          } else {
            throw Exception(
              'Unexpected response data type: ${response.data.runtimeType}',
            );
          }
        },
        validStatusCodes: [200],
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.e('Error downloading file', e, stackTrace);
      rethrow;
    }
  }
}
