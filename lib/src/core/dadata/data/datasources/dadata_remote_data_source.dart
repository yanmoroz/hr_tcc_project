import '../../../base_types/result.dart';
import '../models/dadata_suggestion_model.dart';

/// Remote data source for fetching suggestions from DaData API
abstract class DaDataRemoteDataSource {
  /// Fetch address suggestions based on query
  Future<Result<DaDataSuggestionsResponseModel>> getAddressSuggestions(
    String query,
  );

  /// Fetch country suggestions based on query
  Future<Result<DaDataSuggestionsResponseModel>> getCountrySuggestions(
    String query,
  );

  /// Fetch organization (party) suggestions based on query
  Future<Result<DaDataSuggestionsResponseModel>> getPartySuggestions(
    String query,
  );
}
