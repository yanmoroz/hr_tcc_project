import 'package:fpdart/fpdart.dart';

import '../../../base_types/base_repository.dart';
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
import '../../dictionaries_cache.dart';
import '../../domain/repositories/dictionaries_repository.dart';
import '../datasources/dictionaries_remote_data_source.dart';
import '../models/alpina_digital_prev_access_model.dart';
import '../models/application_form_group_model.dart';
import '../models/application_form_model.dart';
import '../models/office_model.dart';
import '../models/system_status_group_model.dart';
import '../models/system_status_model.dart';
import '../models/training_form_model.dart';
import '../models/training_month_model.dart';
import '../models/training_type_model.dart';
import '../models/trip_purpose_model.dart';

class DictionariesRepositoryImpl
    with BaseRepository
    implements DictionariesRepository {
  final DictionariesRemoteDataSource _remoteDataSource;
  final DictionariesCache _cache;

  DictionariesRepositoryImpl(this._remoteDataSource, this._cache);

  @override
  void clearCache() {
    _cache.clearAll();
  }

  @override
  Future<Result<void>> fetchAndCacheAllDictionaries() async {
    final result = await _remoteDataSource.fetchAllCoreDictionaries();
    return result.fold((failure) => Left(failure), (dictionaries) {
      try {
        final applicationFormGroups = dictionaries.applicationFormGroups
            .map((model) => model.toDomain())
            .toList();
        final applicationForms = dictionaries.applicationForms
            .map((model) => model.toDomain())
            .toList();
        final systemStatusGroups = dictionaries.systemStatusesGroups
            .map((model) => model.toDomain())
            .toList();
        final systemStatuses = dictionaries.systemStatuses
            .map((model) => model.toDomain())
            .toList();
        final tripPurposes = dictionaries.tripPurposes
            .map((model) => model.toDomain())
            .toList();
        final trainingTypes = dictionaries.trainingTypes
            .map((model) => model.toDomain())
            .toList();
        final trainingForms = dictionaries.trainingForms
            .map((model) => model.toDomain())
            .toList();
        final trainingMonths = dictionaries.trainingMonths
            .map((model) => model.toDomain())
            .toList();
        final alpinaDigitalPrevAccesses = dictionaries.alpinaDigitalPrevAccesses
            .map((model) => model.toDomain())
            .toList();
        final offices = dictionaries.offices
            .map((model) => model.toDomain())
            .toList();

        _cache.set<List<ApplicationFormGroup>>(applicationFormGroups);
        _cache.set<List<ApplicationForm>>(applicationForms);
        _cache.set<List<SystemStatusGroup>>(systemStatusGroups);
        _cache.set<List<SystemStatus>>(systemStatuses);
        _cache.set<List<TripPurpose>>(tripPurposes);
        _cache.set<List<TrainingType>>(trainingTypes);
        _cache.set<List<TrainingForm>>(trainingForms);
        _cache.set<List<TrainingMonth>>(trainingMonths);
        _cache.set<List<AlpinaDigitalPrevAccess>>(alpinaDigitalPrevAccesses);
        _cache.set<List<Office>>(offices);

        return Right(null);
      } catch (e) {
        _cache.clearAll();
        return Left(Exception('Failed to map dictionaries: $e'));
      }
    });
  }

  @override
  Future<Result<List<ApplicationFormGroup>>> getApplicationFormGroups() async {
    return _getCachedOrFetch(
      _cache.get,
      'Failed to fetch application form groups',
    );
  }

  @override
  Future<Result<List<ApplicationForm>>> getApplicationForms() async {
    return _getCachedOrFetch(_cache.get, 'Failed to fetch application forms');
  }

  @override
  Future<Result<List<SystemStatusGroup>>> getSystemStatusGroups() async {
    return _getCachedOrFetch(
      _cache.get,
      'Failed to fetch system status groups',
    );
  }

  @override
  Future<Result<List<SystemStatus>>> getSystemStatuses() async {
    return _getCachedOrFetch(_cache.get, 'Failed to fetch system statuses');
  }

  @override
  Future<Result<List<TripPurpose>>> getTripPurposes() async {
    return _getCachedOrFetch(_cache.get, 'Failed to fetch trip purposes');
  }

  @override
  Future<Result<List<TrainingType>>> getTrainingTypes() async {
    return _getCachedOrFetch(_cache.get, 'Failed to fetch training types');
  }

  @override
  Future<Result<List<TrainingForm>>> getTrainingForms() async {
    return _getCachedOrFetch(_cache.get, 'Failed to fetch training forms');
  }

  @override
  Future<Result<List<TrainingMonth>>> getTrainingMonths() async {
    return _getCachedOrFetch(_cache.get, 'Failed to fetch training months');
  }

  @override
  Future<Result<List<AlpinaDigitalPrevAccess>>>
  getAlpinaDigitalPrevAccesses() async {
    return _getCachedOrFetch(
      _cache.get,
      'Failed to fetch alpina digital prev accesses',
    );
  }

  @override
  Future<Result<List<Office>>> getOffices() async {
    return _getCachedOrFetch(_cache.get, 'Failed to fetch offices');
  }

  Future<Result<List<T>>> _getCachedOrFetch<T>(
    List<T>? Function() getFromCache,
    String errorMessage,
  ) async {
    final cached = getFromCache();
    if (cached != null) return Right(cached);

    final fetchResult = await fetchAndCacheAllDictionaries();
    if (fetchResult.isLeft()) return Left(fetchResult.swap().toNullable()!);

    final result = getFromCache();
    return result != null ? Right(result) : Left(Exception(errorMessage));
  }
}
