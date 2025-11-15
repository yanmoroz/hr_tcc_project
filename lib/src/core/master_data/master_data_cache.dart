import '../cache/cache_manager.dart';
import '../entities/alpina_digital_prev_access.dart';
import '../entities/application_form.dart';
import '../entities/application_form_group.dart';
import '../entities/office.dart';
import '../entities/system_status.dart';
import '../entities/system_status_group.dart';
import '../entities/training_form.dart';
import '../entities/training_month.dart';
import '../entities/training_type.dart';
import '../entities/trip_purpose.dart';

class MasterDataCache {
  final CacheManager<List<ApplicationFormGroup>> _applicationFormGroupsCache;
  final CacheManager<List<ApplicationForm>> _applicationFormsCache;
  final CacheManager<List<SystemStatusGroup>> _systemStatusGroupsCache;
  final CacheManager<List<SystemStatus>> _systemStatusesCache;
  final CacheManager<List<TripPurpose>> _tripPurposesCache;
  final CacheManager<List<TrainingType>> _trainingTypesCache;
  final CacheManager<List<TrainingForm>> _trainingFormsCache;
  final CacheManager<List<TrainingMonth>> _trainingMonthsCache;
  final CacheManager<List<AlpinaDigitalPrevAccess>>
  _alpinaDigitalPrevAccessesCache;
  final CacheManager<List<Office>> _officesCache;

  MasterDataCache({Duration cacheDuration = const Duration(hours: 1)})
    : _applicationFormGroupsCache = CacheManager(cacheDuration: cacheDuration),
      _applicationFormsCache = CacheManager(cacheDuration: cacheDuration),
      _systemStatusGroupsCache = CacheManager(cacheDuration: cacheDuration),
      _systemStatusesCache = CacheManager(cacheDuration: cacheDuration),
      _tripPurposesCache = CacheManager(cacheDuration: cacheDuration),
      _trainingTypesCache = CacheManager(cacheDuration: cacheDuration),
      _trainingFormsCache = CacheManager(cacheDuration: cacheDuration),
      _trainingMonthsCache = CacheManager(cacheDuration: cacheDuration),
      _alpinaDigitalPrevAccessesCache = CacheManager(
        cacheDuration: cacheDuration,
      ),
      _officesCache = CacheManager(cacheDuration: cacheDuration);

  // Get cached entities
  List<ApplicationFormGroup>? getApplicationFormGroups() =>
      _applicationFormGroupsCache.get();
  List<ApplicationForm>? getApplicationForms() => _applicationFormsCache.get();
  List<SystemStatusGroup>? getSystemStatusGroups() =>
      _systemStatusGroupsCache.get();
  List<SystemStatus>? getSystemStatuses() => _systemStatusesCache.get();
  List<TripPurpose>? getTripPurposes() => _tripPurposesCache.get();
  List<TrainingType>? getTrainingTypes() => _trainingTypesCache.get();
  List<TrainingForm>? getTrainingForms() => _trainingFormsCache.get();
  List<TrainingMonth>? getTrainingMonths() => _trainingMonthsCache.get();
  List<AlpinaDigitalPrevAccess>? getAlpinaDigitalPrevAccesses() =>
      _alpinaDigitalPrevAccessesCache.get();
  List<Office>? getOffices() => _officesCache.get();

  // Set cached entities
  void setApplicationFormGroups(List<ApplicationFormGroup> data) =>
      _applicationFormGroupsCache.set(data);
  void setApplicationForms(List<ApplicationForm> data) =>
      _applicationFormsCache.set(data);
  void setSystemStatusGroups(List<SystemStatusGroup> data) =>
      _systemStatusGroupsCache.set(data);
  void setSystemStatuses(List<SystemStatus> data) =>
      _systemStatusesCache.set(data);
  void setTripPurposes(List<TripPurpose> data) => _tripPurposesCache.set(data);
  void setTrainingTypes(List<TrainingType> data) =>
      _trainingTypesCache.set(data);
  void setTrainingForms(List<TrainingForm> data) =>
      _trainingFormsCache.set(data);
  void setTrainingMonths(List<TrainingMonth> data) =>
      _trainingMonthsCache.set(data);
  void setAlpinaDigitalPrevAccesses(List<AlpinaDigitalPrevAccess> data) =>
      _alpinaDigitalPrevAccessesCache.set(data);
  void setOffices(List<Office> data) => _officesCache.set(data);

  /// Clear all caches
  void clearAll() {
    _applicationFormGroupsCache.clear();
    _applicationFormsCache.clear();
    _systemStatusGroupsCache.clear();
    _systemStatusesCache.clear();
    _tripPurposesCache.clear();
    _trainingTypesCache.clear();
    _trainingFormsCache.clear();
    _trainingMonthsCache.clear();
    _alpinaDigitalPrevAccessesCache.clear();
    _officesCache.clear();
  }

  /// Check if all dictionaries are cached (useful for knowing if we need to fetch)
  bool hasAllDictionaries() {
    return getApplicationFormGroups() != null &&
        getApplicationForms() != null &&
        getSystemStatusGroups() != null &&
        getSystemStatuses() != null &&
        getTripPurposes() != null &&
        getTrainingTypes() != null &&
        getTrainingForms() != null &&
        getTrainingMonths() != null &&
        getAlpinaDigitalPrevAccesses() != null &&
        getOffices() != null;
  }
}
