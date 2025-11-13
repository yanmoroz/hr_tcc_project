import 'package:hr_tcc_project/src/core/types/result.dart';
import 'package:hr_tcc_project/src/shared/master_data/domain/domain.dart';

import '../models/application_detail_model.dart';
import '../models/application_list_response_model.dart';
import '../models/cancel_application_result_model.dart';
import '../models/create_application_result_model.dart';

abstract class ApplicationRemoteDataSource {
  /// Get paginated list of applications with filtering and statistics
  Future<Result<ApplicationListResponseModel>> getApplications({
    required int page,
    required int pageSize,
    StatusGroupType? statusGroup,
    String? search,
  });

  /// Get detailed information about a specific application
  Future<Result<ApplicationDetailModel>> getApplicationDetail(String id);

  /// Create a new application
  Future<Result<CreateApplicationResultModel>> createApplication(
    Map<String, dynamic> request,
  );

  /// Cancel an application
  Future<Result<CancelApplicationResultModel>> cancelApplication(String id);

  /// Check the completion status of application cancellation
  Future<Result<CancelApplicationResultModel>> checkCancelStatus(String id);

  /// Check the success of application creation by process ID
  Future<Result<CreateApplicationResultModel>> checkApplicationStatus({
    required String applicationFormCode,
    required String instance,
  });
}
