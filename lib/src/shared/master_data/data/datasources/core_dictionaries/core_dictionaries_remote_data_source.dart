import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';
import 'core_dictionaries_response.dart';

abstract class CoreDictionariesRemoteDataSource {
  Future<Either<NetworkException, CoreDictionariesResponse>> getCoreDictionaries();
}

class CoreDictionariesRemoteDataSourceImpl implements CoreDictionariesRemoteDataSource {
  final ApiClient _apiClient;

  CoreDictionariesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, CoreDictionariesResponse>> getCoreDictionaries() async {
    try {
      final response = await _apiClient.get(ApiConstants.coreDictionariesEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        final applicationFormGroups =
            (data['applicationFormGroups'] as List<dynamic>?)
                ?.map((json) => ApplicationFormGroupModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            <ApplicationFormGroupModel>[];

        final applicationForms =
            (data['applicationForms'] as List<dynamic>?)
                ?.map((json) => ApplicationFormModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            <ApplicationFormModel>[];

        final systemStatusesGroups =
            (data['systemStatusesGroups'] as List<dynamic>?)
                ?.map((json) => SystemStatusGroupModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            <SystemStatusGroupModel>[];

        final systemStatuses =
            (data['systemStatuses'] as List<dynamic>?)
                ?.map((json) => SystemStatusModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            <SystemStatusModel>[];

        final tripPurposes =
            (data['tripPurposes'] as List<dynamic>?)
                ?.map((json) => TripPurposeModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            <TripPurposeModel>[];

        final trainingTypes =
            (data['trainingTypes'] as List<dynamic>?)
                ?.map((json) => TrainingTypeModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            <TrainingTypeModel>[];

        final trainingForms =
            (data['trainingForms'] as List<dynamic>?)
                ?.map((json) => TrainingFormModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            <TrainingFormModel>[];

        final trainingMonths =
            (data['trainingMonths'] as List<dynamic>?)
                ?.map((json) => TrainingMonthModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            <TrainingMonthModel>[];

        final alpinaDigitalPrevAccesses =
            (data['alpinaDigitalPrevAccesses'] as List<dynamic>?)
                ?.map((json) => AlpinaDigitalPrevAccessModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            <AlpinaDigitalPrevAccessModel>[];

        final offices =
            (data['dictOffices'] as List<dynamic>?)
                ?.map((json) => OfficeModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            <OfficeModel>[];

        return Right(
          CoreDictionariesResponse(
            applicationFormGroups: applicationFormGroups,
            applicationForms: applicationForms,
            systemStatusesGroups: systemStatusesGroups,
            systemStatuses: systemStatuses,
            tripPurposes: tripPurposes,
            trainingTypes: trainingTypes,
            trainingForms: trainingForms,
            trainingMonths: trainingMonths,
            alpinaDigitalPrevAccesses: alpinaDigitalPrevAccesses,
            offices: offices,
          ),
        );
      } else {
        return Left(
          NetworkException.fromDioError(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
            ),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    } catch (e) {
      return Left(
        NetworkException.fromDioError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            error: e,
            type: DioExceptionType.unknown,
          ),
        ),
      );
    }
  }
}
