import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/base_types/result.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/value_objects/system_type.dart';
import '../../../../core/value_objects/tcc_image_destination_type.dart';
import '../../domain/domain.dart';
import '../models/uploaded_file_model.dart';
import 'file_remote_data_source.dart';

class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final ApiClient _apiClient;

  FileRemoteDataSourceImpl(this._apiClient);

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

      // Add TCC-specific parameters
      if (systemType == SystemType.tcc) {
        if (imageDestination != null) {
          queryParameters['imageDestination'] = imageDestination.value;
        }
        if (destinationId != null) {
          queryParameters['destinationId'] = destinationId;
        }
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

  @override
  Future<Result<UploadedFileModel>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    TccImageDestinationType? imageDestination,
    String? destinationId,
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

      if (systemType == SystemType.tcc) {
        if (imageDestination != null) {
          queryParameters['imageDestination'] = imageDestination.value;
        }
        if (destinationId != null) {
          queryParameters['destinationId'] = destinationId;
        }
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
          // Freezed union automatically handles systemType discrimination
          return UploadedFileModel.fromJson(json);
        },
        validStatusCodes: [200],
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.e('Error uploading file', e, stackTrace);
      rethrow;
    }
  }
}
