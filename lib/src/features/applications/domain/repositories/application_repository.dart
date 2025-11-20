import '../../../../core/base_types/result.dart';
import '../../../../core/value_objects/status_group_type.dart';
import '../entities/application_detail.dart';
import '../entities/kp_absence_category.dart';
import '../params/create_application_params.dart';
import '../results/cancel_application_result.dart';
import '../results/check_application_status_result.dart';
import '../results/check_cancel_status_result.dart';
import '../results/create_application_result.dart';
import '../results/get_applications_result.dart';

abstract class ApplicationRepository {
  /// Get paginated list of applications with filtering and statistics
  Future<Result<GetApplicationsResult>> getApplications({
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
    CreateApplicationParams params,
  );

  /// Cancel an application
  /// Returns result with status (ok/processing), applicationId, and systemStatus
  Future<Result<CancelApplicationResult>> cancelApplication(String id);

  /// Check the completion status of application cancellation
  Future<Result<CheckCancelStatusResult>> checkCancelStatus(String id);

  /// Check the success of application creation by process ID
  Future<Result<CheckApplicationStatusResult>> checkApplicationStatus({
    required String applicationFormCode,
    required String instance,
  });

  /// Get KP absence categories
  Future<Result<List<KpAbsenceCategory>>> getKpAbsenceCategories();
}
