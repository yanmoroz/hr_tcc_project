import '../../../../core/base_types/result.dart';
import '../../../../core/entities/system_status.dart';
import '../../../../core/value_objects/application_status.dart';
import '../../../../core/value_objects/status_group_type.dart';
import '../entities/application_detail.dart';
import '../entities/application_info.dart';
import '../entities/application_statistics.dart';
import '../params/create_application_params.dart';

abstract class ApplicationRepository {
  /// Get paginated list of applications with filtering and statistics
  Future<Result<(List<ApplicationInfo>, int, List<ApplicationStatistics>)>>
  getApplications({
    required int page,
    required int pageSize,
    StatusGroupType? statusGroup,
    String? search,
  });

  /// Get detailed information about a specific application
  Future<Result<ApplicationDetail>> getApplicationDetail(String id);

  /// Create a new application
  /// Returns result with status (ok/processing), instanceId, and applicationId
  Future<
    Result<
      ({
        ApplicationStatus status,
        String? instance,
        String? id,
        String? idApplication,
      })
    >
  >
  createApplication(CreateApplicationParams params);

  /// Cancel an application
  /// Returns result with status (ok/processing), applicationId, and systemStatus
  Future<
    Result<({ApplicationStatus status, String id, SystemStatus systemStatus})>
  >
  cancelApplication(String id);

  /// Check the completion status of application cancellation
  Future<
    Result<({ApplicationStatus status, String id, SystemStatus systemStatus})>
  >
  checkCancelStatus(String id);

  /// Check the success of application creation by process ID
  Future<
    Result<
      ({
        ApplicationStatus status,
        String? instance,
        String? id,
        String? idApplication,
      })
    >
  >
  checkApplicationStatus({
    required String applicationFormCode,
    required String instance,
  });
}
