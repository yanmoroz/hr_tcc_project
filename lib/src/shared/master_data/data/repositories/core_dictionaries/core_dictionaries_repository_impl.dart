import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class CoreDictionariesRepositoryImpl implements CoreDictionariesRepository {
  final CoreDictionariesRemoteDataSource _remoteDataSource;
  CoreDictionariesResponse? _cachedResponse;

  CoreDictionariesRepositoryImpl(this._remoteDataSource);

  Future<Either<NetworkException, CoreDictionariesResponse>> _getResponse() async {
    if (_cachedResponse != null) {
      return Right(_cachedResponse!);
    }

    final result = await _remoteDataSource.getCoreDictionaries();
    result.fold((failure) => null, (response) => _cachedResponse = response);
    return result;
  }

  @override
  Future<Either<NetworkException, List<ApplicationFormGroup>>> getApplicationFormGroups() async {
    final result = await _getResponse();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.applicationFormGroups.map((model) => model.toDomain()).toList()),
    );
  }

  @override
  Future<Either<NetworkException, List<ApplicationForm>>> getApplicationForms() async {
    final result = await _getResponse();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.applicationForms.map((model) => model.toDomain()).toList()),
    );
  }

  @override
  Future<Either<NetworkException, List<SystemStatusGroup>>> getSystemStatusGroups() async {
    final result = await _getResponse();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.systemStatusesGroups.map((model) => model.toDomain()).toList()),
    );
  }

  @override
  Future<Either<NetworkException, List<SystemStatus>>> getSystemStatuses() async {
    final result = await _getResponse();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.systemStatuses.map((model) => model.toDomain()).toList()),
    );
  }

  @override
  Future<Either<NetworkException, List<TripPurpose>>> getTripPurposes() async {
    final result = await _getResponse();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.tripPurposes.map((model) => model.toDomain()).toList()),
    );
  }

  @override
  Future<Either<NetworkException, List<TrainingType>>> getTrainingTypes() async {
    final result = await _getResponse();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.trainingTypes.map((model) => model.toDomain()).toList()),
    );
  }

  @override
  Future<Either<NetworkException, List<TrainingForm>>> getTrainingForms() async {
    final result = await _getResponse();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.trainingForms.map((model) => model.toDomain()).toList()),
    );
  }

  @override
  Future<Either<NetworkException, List<TrainingMonth>>> getTrainingMonths() async {
    final result = await _getResponse();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.trainingMonths.map((model) => model.toDomain()).toList()),
    );
  }

  @override
  Future<Either<NetworkException, List<AlpinaDigitalPrevAccess>>> getAlpinaDigitalPrevAccess() async {
    final result = await _getResponse();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.alpinaDigitalPrevAccesses.map((model) => model.toDomain()).toList()),
    );
  }

  @override
  Future<Either<NetworkException, List<Office>>> getOffices() async {
    final result = await _getResponse();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.offices.map((model) => model.toDomain()).toList()),
    );
  }
}
