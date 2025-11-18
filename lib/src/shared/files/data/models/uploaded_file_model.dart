import '../../../../core/value_objects/system_type.dart';
import '../../domain/domain.dart';
import 'elma_upload_file_response_model.dart';
import 'jira_upload_file_response_model.dart';
import 'kp_upload_file_response_model.dart';
import 'tcc_upload_file_response_model.dart';

/// Unified upload response model - handles different system types
/// Note: Using a simpler approach without union for _1C since it's not commonly used
class UploadedFileModel {
  final ElmaUploadFileResponseModel? elmaData;
  final JiraUploadFileResponseModel? jiraData;
  final KpUploadFileResponseModel? kpData;
  final TccUploadFileResponseModel? tccData;
  final Map<String, dynamic>? oneCData;
  final SystemType systemType;

  UploadedFileModel._({
    this.elmaData,
    this.jiraData,
    this.kpData,
    this.tccData,
    this.oneCData,
    required this.systemType,
  });

  factory UploadedFileModel.elma(ElmaUploadFileResponseModel data) {
    return UploadedFileModel._(elmaData: data, systemType: SystemType.elma);
  }

  factory UploadedFileModel.jira(JiraUploadFileResponseModel data) {
    return UploadedFileModel._(jiraData: data, systemType: SystemType.jira);
  }

  factory UploadedFileModel.kp(KpUploadFileResponseModel data) {
    return UploadedFileModel._(kpData: data, systemType: SystemType.kp);
  }

  factory UploadedFileModel.tcc(TccUploadFileResponseModel data) {
    return UploadedFileModel._(tccData: data, systemType: SystemType.tcc);
  }

  factory UploadedFileModel.oneC(Map<String, dynamic> data) {
    return UploadedFileModel._(
      oneCData: data,
      systemType: SystemType.values.firstWhere((e) => e.value == '_1C'),
    );
  }

  /// Parse JSON response with automatic systemType detection from JSON (like Java JsonTypeInfo)
  factory UploadedFileModel.fromJson(Map<String, dynamic> json) {
    final systemTypeStr = json['systemType'] as String?;
    if (systemTypeStr == null) {
      throw ArgumentError('systemType is required in JSON response');
    }
    final systemType = SystemType.fromString(systemTypeStr);
    return UploadedFileModel.fromJsonWithSystemType(json, systemType);
  }

  /// Parse JSON response with explicit systemType (for backward compatibility)
  factory UploadedFileModel.fromJsonWithSystemType(
    Map<String, dynamic> json,
    SystemType systemType,
  ) {
    switch (systemType) {
      case SystemType.elma:
        return UploadedFileModel.elma(
          ElmaUploadFileResponseModel.fromJson(json),
        );
      case SystemType.jira:
        return UploadedFileModel.jira(
          JiraUploadFileResponseModel.fromJson(json),
        );
      case SystemType.kp:
        return UploadedFileModel.kp(KpUploadFileResponseModel.fromJson(json));
      case SystemType.tcc:
        return UploadedFileModel.tcc(TccUploadFileResponseModel.fromJson(json));
      default:
        // Handle _1C case
        if (systemType.value == '_1C') {
          return UploadedFileModel.oneC(json);
        }
        throw UnsupportedError('Unsupported system type: ${systemType.value}');
    }
  }
}

extension UploadedFileModelX on UploadedFileModel {
  UploadedFile toDomain() {
    switch (systemType) {
      case SystemType.elma:
        return elmaData!.toDomain();
      case SystemType.jira:
        return jiraData!.toDomain();
      case SystemType.kp:
        return kpData!.toDomain();
      case SystemType.tcc:
        return tccData!.toDomain();
      default:
        // Handle _1C case
        if (systemType.value == '_1C') {
          return UploadedFile.oneC();
        }
        throw UnsupportedError('Unsupported system type: ${systemType.value}');
    }
  }
}
