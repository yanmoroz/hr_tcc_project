import 'package:fpdart/fpdart.dart';

import '../domain/entities/system_status.dart';
import '../domain/entities/application_form_group.dart';
import '../domain/entities/application_form.dart';
import '../domain/entities/system_status_group.dart';
import '../domain/entities/trip_purpose.dart';
import '../domain/entities/training_type.dart';
import '../domain/entities/training_form.dart';
import '../domain/entities/training_month.dart';
import '../domain/entities/alpina_digital_prev_access.dart';
import '../domain/entities/office.dart';
import '../base_types/result.dart';
import 'master_data_cache.dart';
import 'master_data_remote_data_source.dart';

/// Unified repository for all master/reference data
///
/// Provides centralized access to dictionaries with built-in caching.
/// Replaces the need for individual repositories and use cases for each dictionary type.
///
/// Orchestrates between MasterDataRemoteDataSource (fetching) and MasterDataCache (caching).
class MasterDataRepository {
  final MasterDataRemoteDataSource _remoteDataSource;
  final MasterDataCache _cache;

  MasterDataRepository(this._remoteDataSource, this._cache);

  /// Clears all cached data, forcing fresh fetch on next request
  void clearCache() {
    _cache.clearAll();
  }

  /// Internal method to fetch all core dictionaries and cache them
  ///
  /// All core dictionaries come from a single bundled API endpoint,
  /// so we fetch them all at once and cache each type separately as entities.
  Future<void> _fetchAndCacheAllDictionaries() async {
    // Fetch from remote (already converted to entities by data source)
    final result = await _remoteDataSource.fetchAllCoreDictionaries();

    // On success, cache all dictionary types
    result.fold(
      (failure) => null, // Do nothing on failure
      (dictionaries) {
        _cache.setApplicationFormGroups(dictionaries.applicationFormGroups);
        _cache.setApplicationForms(dictionaries.applicationForms);
        _cache.setSystemStatusGroups(dictionaries.systemStatusGroups);
        _cache.setSystemStatuses(dictionaries.systemStatuses);
        _cache.setTripPurposes(dictionaries.tripPurposes);
        _cache.setTrainingTypes(dictionaries.trainingTypes);
        _cache.setTrainingForms(dictionaries.trainingForms);
        _cache.setTrainingMonths(dictionaries.trainingMonths);
        _cache.setAlpinaDigitalPrevAccesses(
          dictionaries.alpinaDigitalPrevAccesses,
        );
        _cache.setOffices(dictionaries.offices);
      },
    );
  }

  // ============================================================================
  // Core Dictionaries (Bundled Endpoint)
  // ============================================================================

  Future<Result<List<ApplicationFormGroup>>> getApplicationFormGroups() async {
    // Check cache first
    final cached = _cache.getApplicationFormGroups();
    if (cached != null) {
      return Right(cached);
    }

    // Fetch and cache all dictionaries
    await _fetchAndCacheAllDictionaries();

    // Return from cache (or error if fetch failed)
    final result = _cache.getApplicationFormGroups();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch application form groups'));
  }

  Future<Result<List<ApplicationForm>>> getApplicationForms() async {
    final cached = _cache.getApplicationForms();
    if (cached != null) return Right(cached);

    await _fetchAndCacheAllDictionaries();

    final result = _cache.getApplicationForms();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch application forms'));
  }

  Future<Result<List<SystemStatusGroup>>> getSystemStatusGroups() async {
    final cached = _cache.getSystemStatusGroups();
    if (cached != null) return Right(cached);

    await _fetchAndCacheAllDictionaries();

    final result = _cache.getSystemStatusGroups();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch system status groups'));
  }

  Future<Result<List<SystemStatus>>> getSystemStatuses() async {
    final cached = _cache.getSystemStatuses();
    if (cached != null) return Right(cached);

    await _fetchAndCacheAllDictionaries();

    final result = _cache.getSystemStatuses();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch system statuses'));
  }

  Future<Result<List<TripPurpose>>> getTripPurposes() async {
    final cached = _cache.getTripPurposes();
    if (cached != null) return Right(cached);

    await _fetchAndCacheAllDictionaries();

    final result = _cache.getTripPurposes();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch trip purposes'));
  }

  Future<Result<List<TrainingType>>> getTrainingTypes() async {
    final cached = _cache.getTrainingTypes();
    if (cached != null) return Right(cached);

    await _fetchAndCacheAllDictionaries();

    final result = _cache.getTrainingTypes();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch training types'));
  }

  Future<Result<List<TrainingForm>>> getTrainingForms() async {
    final cached = _cache.getTrainingForms();
    if (cached != null) return Right(cached);

    await _fetchAndCacheAllDictionaries();

    final result = _cache.getTrainingForms();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch training forms'));
  }

  Future<Result<List<TrainingMonth>>> getTrainingMonths() async {
    final cached = _cache.getTrainingMonths();
    if (cached != null) return Right(cached);

    await _fetchAndCacheAllDictionaries();

    final result = _cache.getTrainingMonths();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch training months'));
  }

  Future<Result<List<AlpinaDigitalPrevAccess>>>
  getAlpinaDigitalPrevAccesses() async {
    final cached = _cache.getAlpinaDigitalPrevAccesses();
    if (cached != null) return Right(cached);

    await _fetchAndCacheAllDictionaries();

    final result = _cache.getAlpinaDigitalPrevAccesses();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch alpina digital prev accesses'));
  }

  Future<Result<List<Office>>> getOffices() async {
    final cached = _cache.getOffices();
    if (cached != null) return Right(cached);

    await _fetchAndCacheAllDictionaries();

    final result = _cache.getOffices();
    return result != null
        ? Right(result)
        : Left(Exception('Failed to fetch offices'));
  }

  // ============================================================================
  // Individual Dictionaries (Separate Endpoints)
  // Note: These are feature-specific and should eventually move to their
  // respective feature modules. For now, they remain accessible here for
  // backwards compatibility.
  // ============================================================================

  // TODO: Move other feature-specific dictionaries to their features
}
