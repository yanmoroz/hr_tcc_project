import 'package:fpdart/fpdart.dart';

import '../../base_types/base_repository.dart';
import '../../entities/system_status.dart';
import '../../entities/application_form_group.dart';
import '../../entities/application_form.dart';
import '../../entities/system_status_group.dart';
import '../../entities/trip_purpose.dart';
import '../../entities/training_type.dart';
import '../../entities/training_form.dart';
import '../../entities/training_month.dart';
import '../../entities/alpina_digital_prev_access.dart';
import '../../entities/office.dart';
import '../../base_types/result.dart';
import '../master_data_cache.dart';
import '../datasources/master_data_remote_data_source.dart';
import 'master_data_repository.dart';

import '../models/application_form_group_model.dart';
import '../models/application_form_model.dart';
import '../models/system_status_group_model.dart';
import '../models/system_status_model.dart';
import '../models/trip_purpose_model.dart';
import '../models/training_type_model.dart';
import '../models/training_form_model.dart';
import '../models/training_month_model.dart';
import '../models/alpina_digital_prev_access_model.dart';
import '../models/office_model.dart';

class MasterDataRepositoryImpl
    with BaseRepository
    implements MasterDataRepository {
  final MasterDataRemoteDataSource _remoteDataSource;
  final MasterDataCache _cache;

  MasterDataRepositoryImpl(this._remoteDataSource, this._cache);

  @override
  void clearCache() {
    _cache.clearAll();
  }

  @override
  Future<Result<void>> fetchAndCacheAllDictionaries() async {
    final result = await _remoteDataSource.fetchAllCoreDictionaries();

    return result.fold((failure) => Left(failure), (dictionaries) {
      _cache.setApplicationFormGroups(
        dictionaries.applicationFormGroups
            .map((model) => model.toDomain())
            .toList(),
      );
      _cache.setApplicationForms(
        dictionaries.applicationForms.map((model) => model.toDomain()).toList(),
      );
      _cache.setSystemStatusGroups(
        dictionaries.systemStatusesGroups
            .map((model) => model.toDomain())
            .toList(),
      );
      _cache.setSystemStatuses(
        dictionaries.systemStatuses.map((model) => model.toDomain()).toList(),
      );
      _cache.setTripPurposes(
        dictionaries.tripPurposes.map((model) => model.toDomain()).toList(),
      );
      _cache.setTrainingTypes(
        dictionaries.trainingTypes.map((model) => model.toDomain()).toList(),
      );
      _cache.setTrainingForms(
        dictionaries.trainingForms.map((model) => model.toDomain()).toList(),
      );
      _cache.setTrainingMonths(
        dictionaries.trainingMonths.map((model) => model.toDomain()).toList(),
      );
      _cache.setAlpinaDigitalPrevAccesses(
        dictionaries.alpinaDigitalPrevAccesses
            .map((model) => model.toDomain())
            .toList(),
      );
      _cache.setOffices(
        dictionaries.offices.map((model) => model.toDomain()).toList(),
      );
      return Right(null);
    });
  }

  @override
  Future<Result<List<ApplicationFormGroup>>> getApplicationFormGroups() async {
    final cached = _cache.getApplicationFormGroups();
    if (cached != null) {
      return Right(cached);
    }

    await fetchAndCacheAllDictionaries();

    final result = _cache.getApplicationFormGroups();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch application form groups'));
  }

  @override
  Future<Result<List<ApplicationForm>>> getApplicationForms() async {
    final cached = _cache.getApplicationForms();
    if (cached != null) return Right(cached);

    await fetchAndCacheAllDictionaries();

    final result = _cache.getApplicationForms();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch application forms'));
  }

  @override
  Future<Result<List<SystemStatusGroup>>> getSystemStatusGroups() async {
    final cached = _cache.getSystemStatusGroups();
    if (cached != null) return Right(cached);

    await fetchAndCacheAllDictionaries();

    final result = _cache.getSystemStatusGroups();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch system status groups'));
  }

  @override
  Future<Result<List<SystemStatus>>> getSystemStatuses() async {
    final cached = _cache.getSystemStatuses();
    if (cached != null) return Right(cached);

    await fetchAndCacheAllDictionaries();

    final result = _cache.getSystemStatuses();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch system statuses'));
  }

  @override
  Future<Result<List<TripPurpose>>> getTripPurposes() async {
    final cached = _cache.getTripPurposes();
    if (cached != null) return Right(cached);

    await fetchAndCacheAllDictionaries();

    final result = _cache.getTripPurposes();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch trip purposes'));
  }

  @override
  Future<Result<List<TrainingType>>> getTrainingTypes() async {
    final cached = _cache.getTrainingTypes();
    if (cached != null) return Right(cached);

    await fetchAndCacheAllDictionaries();

    final result = _cache.getTrainingTypes();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch training types'));
  }

  @override
  Future<Result<List<TrainingForm>>> getTrainingForms() async {
    final cached = _cache.getTrainingForms();
    if (cached != null) return Right(cached);

    await fetchAndCacheAllDictionaries();

    final result = _cache.getTrainingForms();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch training forms'));
  }

  @override
  Future<Result<List<TrainingMonth>>> getTrainingMonths() async {
    final cached = _cache.getTrainingMonths();
    if (cached != null) return Right(cached);

    await fetchAndCacheAllDictionaries();

    final result = _cache.getTrainingMonths();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch training months'));
  }

  @override
  Future<Result<List<AlpinaDigitalPrevAccess>>>
  getAlpinaDigitalPrevAccesses() async {
    final cached = _cache.getAlpinaDigitalPrevAccesses();
    if (cached != null) return Right(cached);

    await fetchAndCacheAllDictionaries();

    final result = _cache.getAlpinaDigitalPrevAccesses();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch alpina digital prev accesses'));
  }

  @override
  Future<Result<List<Office>>> getOffices() async {
    final cached = _cache.getOffices();
    if (cached != null) return Right(cached);

    await fetchAndCacheAllDictionaries();

    final result = _cache.getOffices();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch offices'));
  }
}
