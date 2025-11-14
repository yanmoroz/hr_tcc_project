import '../../../../core/types/result.dart';

import '../domain.dart';

abstract class CoreDictionariesRepository {
  Future<Result<List<ApplicationFormGroup>>> getApplicationFormGroups();
  Future<Result<List<ApplicationForm>>> getApplicationForms();
  Future<Result<List<SystemStatusGroup>>> getSystemStatusGroups();
  Future<Result<List<SystemStatus>>> getSystemStatuses();
  Future<Result<List<TripPurpose>>> getTripPurposes();
  Future<Result<List<TrainingType>>> getTrainingTypes();
  Future<Result<List<TrainingForm>>> getTrainingForms();
  Future<Result<List<TrainingMonth>>> getTrainingMonths();
  Future<Result<List<AlpinaDigitalPrevAccess>>> getAlpinaDigitalPrevAccess();
  Future<Result<List<Office>>> getOffices();
}
