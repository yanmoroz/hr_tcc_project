import '../domain/entities/alpina_digital_prev_access.dart';
import '../domain/entities/application_form.dart';
import '../domain/entities/application_form_group.dart';
import '../domain/entities/office.dart';
import '../domain/entities/system_status.dart';
import '../domain/entities/system_status_group.dart';
import '../domain/entities/training_form.dart';
import '../domain/entities/training_month.dart';
import '../domain/entities/training_type.dart';
import '../domain/entities/trip_purpose.dart';
import '../network/api_call_executor.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../types/result.dart';
import 'models/alpina_digital_prev_access_model.dart';
import 'models/application_form_group_model.dart';
import 'models/application_form_model.dart';
import 'models/core_dictionaries_response_model.dart';
import 'models/office_model.dart';
import 'models/system_status_group_model.dart';
import 'models/system_status_model.dart';
import 'models/training_form_model.dart';
import 'models/training_month_model.dart';
import 'models/training_type_model.dart';
import 'models/trip_purpose_model.dart';

/// Remote data source for master data
///
/// Fetches data from API and converts models to domain entities.
/// Handles all the model-to-entity conversion logic.
/// Self-contained - does not depend on legacy data sources.
class MasterDataRemoteDataSource {
  final ApiClient _apiClient;

  MasterDataRemoteDataSource(this._apiClient);

  /// Fetch all core dictionaries and return them as entities
  ///
  /// Returns a record with all dictionary types as separate fields.
  /// On error, returns Left with the exception.
  Future<Result<CoreDictionaries>> fetchAllCoreDictionaries() async {
    // Fetch from API
    final result = await ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.coreDictionariesEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CoreDictionariesResponseModel.fromJson(data);
      },
    );

    // Convert models to entities
    return result.map(
      (response) => CoreDictionaries(
        applicationFormGroups: response.applicationFormGroups
            .map((m) => m.toDomain())
            .toList(),
        applicationForms: response.applicationForms
            .map((m) => m.toDomain())
            .toList(),
        systemStatusGroups: response.systemStatusesGroups
            .map((m) => m.toDomain())
            .toList(),
        systemStatuses: response.systemStatuses
            .map((m) => m.toDomain())
            .toList(),
        tripPurposes: response.tripPurposes.map((m) => m.toDomain()).toList(),
        trainingTypes: response.trainingTypes.map((m) => m.toDomain()).toList(),
        trainingForms: response.trainingForms.map((m) => m.toDomain()).toList(),
        trainingMonths: response.trainingMonths
            .map((m) => m.toDomain())
            .toList(),
        alpinaDigitalPrevAccesses: response.alpinaDigitalPrevAccesses
            .map((m) => m.toDomain())
            .toList(),
        offices: response.offices.map((m) => m.toDomain()).toList(),
      ),
    );
  }
}

/// Container for all core dictionaries as entities
class CoreDictionaries {
  final List<ApplicationFormGroup> applicationFormGroups;
  final List<ApplicationForm> applicationForms;
  final List<SystemStatusGroup> systemStatusGroups;
  final List<SystemStatus> systemStatuses;
  final List<TripPurpose> tripPurposes;
  final List<TrainingType> trainingTypes;
  final List<TrainingForm> trainingForms;
  final List<TrainingMonth> trainingMonths;
  final List<AlpinaDigitalPrevAccess> alpinaDigitalPrevAccesses;
  final List<Office> offices;

  CoreDictionaries({
    required this.applicationFormGroups,
    required this.applicationForms,
    required this.systemStatusGroups,
    required this.systemStatuses,
    required this.tripPurposes,
    required this.trainingTypes,
    required this.trainingForms,
    required this.trainingMonths,
    required this.alpinaDigitalPrevAccesses,
    required this.offices,
  });
}
