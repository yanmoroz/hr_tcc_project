import '../../../../core/base_types/result.dart';
import '../../../../core/value_objects/status_group_type.dart';
import '../models/requests/create_application_request_model.dart';
import '../models/responses/application_detail_model.dart';
import '../models/responses/application_list_response_model.dart';
import '../models/responses/cancel_application_result_model.dart';
import '../models/responses/create_application_result_model.dart';
import '../models/responses/kp_absence_category_model.dart';

abstract class ApplicationRemoteDataSource {
  Future<Result<CancelApplicationResultModel>> cancelApplication(String id);

  Future<Result<CreateApplicationResultModel>> checkApplicationStatus({
    required String applicationFormCode,
    required String instance,
  });

  Future<Result<CancelApplicationResultModel>> checkCancelStatus(String id);

  Future<Result<CreateApplicationResultModel>> createApplication(
    CreateApplicationRequestModel request,
  );

  Future<Result<ApplicationDetailModel>> getApplicationDetail(String id);

  Future<Result<ApplicationListResponseModel>> getApplications({
    required int page,
    required int pageSize,
    StatusGroupType? statusGroup,
    String? search,
  });

  Future<Result<List<KpAbsenceCategoryModel>>> getKpAbsenceCategories();
}
