import '../base_types/result.dart';

/// Service for DaData address/organization/country suggestions
abstract class DaDataService {
  /// Get address suggestions for the given query
  Future<Result<List<String>>> getAddressSuggestions(String query);

  /// Get country suggestions for the given query
  Future<Result<List<String>>> getCountrySuggestions(String query);

  /// Get organization (party) suggestions for the given query
  Future<Result<List<String>>> getPartySuggestions(String query);
}
