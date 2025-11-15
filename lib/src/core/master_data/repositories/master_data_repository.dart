import '../../base_types/result.dart';
import '../../entities/application_form_group.dart';
import '../../entities/application_form.dart';
import '../../entities/system_status_group.dart';
import '../../entities/system_status.dart';
import '../../entities/trip_purpose.dart';
import '../../entities/training_type.dart';
import '../../entities/training_form.dart';
import '../../entities/training_month.dart';
import '../../entities/alpina_digital_prev_access.dart';
import '../../entities/office.dart';

abstract class MasterDataRepository {
  Future<Result<void>> fetchAndCacheAllDictionaries();
  Future<Result<List<ApplicationFormGroup>>> getApplicationFormGroups();
  Future<Result<List<ApplicationForm>>> getApplicationForms();
  Future<Result<List<SystemStatusGroup>>> getSystemStatusGroups();
  Future<Result<List<SystemStatus>>> getSystemStatuses();
  Future<Result<List<TripPurpose>>> getTripPurposes();
  Future<Result<List<TrainingType>>> getTrainingTypes();
  Future<Result<List<TrainingForm>>> getTrainingForms();
  Future<Result<List<TrainingMonth>>> getTrainingMonths();
  Future<Result<List<AlpinaDigitalPrevAccess>>> getAlpinaDigitalPrevAccesses();
  Future<Result<List<Office>>> getOffices();
  void clearCache();
}
