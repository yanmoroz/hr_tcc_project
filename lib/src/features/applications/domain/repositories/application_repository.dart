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
  Future<Result<CancelApplicationResult>> cancelApplication(String id);

  Future<Result<CheckApplicationStatusResult>> checkApplicationStatus({
    required String applicationFormCode,
    required String instance,
  });

  Future<Result<CheckCancelStatusResult>> checkCancelStatus(String id);

  Future<Result<CreateApplicationResult>> createApplication(
    CreateApplicationParams params,
  );

  Future<Result<ApplicationDetail>> getApplicationDetail(String id);

  Future<Result<GetApplicationsResult>> getApplications({
    required int page,
    required int pageSize,
    StatusGroupType? statusGroup,
    String? search,
  });

  Future<Result<List<KpAbsenceCategory>>> getKpAbsenceCategories();
}
