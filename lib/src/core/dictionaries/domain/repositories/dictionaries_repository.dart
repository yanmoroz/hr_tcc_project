import '../../../base_types/result.dart';
import '../../../entities/alpina_digital_prev_access.dart';
import '../../../entities/application_form.dart';
import '../../../entities/application_form_group.dart';
import '../../../entities/office.dart';
import '../../../entities/system_status.dart';
import '../../../entities/system_status_group.dart';
import '../../../entities/training_form.dart';
import '../../../entities/training_month.dart';
import '../../../entities/training_type.dart';
import '../../../entities/trip_purpose.dart';

abstract class DictionariesRepository {
  void clearCache();
  Future<Result<void>> fetchAndCacheAllDictionaries();
  Future<Result<List<AlpinaDigitalPrevAccess>>> getAlpinaDigitalPrevAccesses();
  Future<Result<List<ApplicationFormGroup>>> getApplicationFormGroups();
  Future<Result<List<ApplicationForm>>> getApplicationForms();
  Future<Result<List<Office>>> getOffices();
  Future<Result<List<SystemStatus>>> getSystemStatuses();
  Future<Result<List<SystemStatusGroup>>> getSystemStatusGroups();
  Future<Result<List<TrainingForm>>> getTrainingForms();
  Future<Result<List<TrainingMonth>>> getTrainingMonths();
  Future<Result<List<TrainingType>>> getTrainingTypes();
  Future<Result<List<TripPurpose>>> getTripPurposes();
}
