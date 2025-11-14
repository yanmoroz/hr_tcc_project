import 'package:hr_tcc_project/src/core/types/result.dart';

import '../../../../core/domain/value_objects/status_group_type.dart';
import '../entities/application_detail.dart';
import '../entities/application_info.dart';
import '../entities/application_statistics.dart';
import '../entities/cancel_application_result.dart';
import '../entities/create_application_result.dart';

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
  Future<Result<CreateApplicationResult>> createApplication(
    Map<String, dynamic> request,
  );

  /// Cancel an application
  /// Returns result with status (ok/processing), applicationId, and systemStatus
  Future<Result<CancelApplicationResult>> cancelApplication(String id);

  /// Check the completion status of application cancellation
  Future<Result<CancelApplicationResult>> checkCancelStatus(String id);

  /// Check the success of application creation by process ID
  Future<Result<CreateApplicationResult>> checkApplicationStatus({
    required String applicationFormCode,
    required String instance,
  });
}
