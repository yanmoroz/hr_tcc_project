import 'package:fpdart/fpdart.dart';
import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class CoreDictionariesRepositoryImpl with BaseRepository implements CoreDictionariesRepository {
  final CoreDictionariesRemoteDataSource _remoteDataSource;
  CoreDictionariesResponse? _cachedResponse;

  CoreDictionariesRepositoryImpl(this._remoteDataSource);

  Future<Result<CoreDictionariesResponse>> _getResponse() async {
    if (_cachedResponse != null) {
      return Right(_cachedResponse!);
    }

    final result = await _remoteDataSource.getCoreDictionaries();
    result.fold((failure) => null, (response) => _cachedResponse = response);
    return result;
  }

  @override
  Future<Result<List<ApplicationFormGroup>>> getApplicationFormGroups() async {
    final result = await _getResponse();
    final listResult = mapResult(result, (response) => response.applicationFormGroups);
    return mapResultList(listResult, (model) => model.toDomain());
  }

  @override
  Future<Result<List<ApplicationForm>>> getApplicationForms() async {
    final result = await _getResponse();
    final listResult = mapResult(result, (response) => response.applicationForms);
    return mapResultList(listResult, (model) => model.toDomain());
  }

  @override
  Future<Result<List<SystemStatusGroup>>> getSystemStatusGroups() async {
    final result = await _getResponse();
    final listResult = mapResult(result, (response) => response.systemStatusesGroups);
    return mapResultList(listResult, (model) => model.toDomain());
  }

  @override
  Future<Result<List<SystemStatus>>> getSystemStatuses() async {
    final result = await _getResponse();
    final listResult = mapResult(result, (response) => response.systemStatuses);
    return mapResultList(listResult, (model) => model.toDomain());
  }

  @override
  Future<Result<List<TripPurpose>>> getTripPurposes() async {
    final result = await _getResponse();
    final listResult = mapResult(result, (response) => response.tripPurposes);
    return mapResultList(listResult, (model) => model.toDomain());
  }

  @override
  Future<Result<List<TrainingType>>> getTrainingTypes() async {
    final result = await _getResponse();
    final listResult = mapResult(result, (response) => response.trainingTypes);
    return mapResultList(listResult, (model) => model.toDomain());
  }

  @override
  Future<Result<List<TrainingForm>>> getTrainingForms() async {
    final result = await _getResponse();
    final listResult = mapResult(result, (response) => response.trainingForms);
    return mapResultList(listResult, (model) => model.toDomain());
  }

  @override
  Future<Result<List<TrainingMonth>>> getTrainingMonths() async {
    final result = await _getResponse();
    final listResult = mapResult(result, (response) => response.trainingMonths);
    return mapResultList(listResult, (model) => model.toDomain());
  }

  @override
  Future<Result<List<AlpinaDigitalPrevAccess>>> getAlpinaDigitalPrevAccess() async {
    final result = await _getResponse();
    final listResult = mapResult(result, (response) => response.alpinaDigitalPrevAccesses);
    return mapResultList(listResult, (model) => model.toDomain());
  }

  @override
  Future<Result<List<Office>>> getOffices() async {
    final result = await _getResponse();
    final listResult = mapResult(result, (response) => response.offices);
    return mapResultList(listResult, (model) => model.toDomain());
  }
}
