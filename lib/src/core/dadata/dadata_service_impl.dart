import '../base_types/result.dart';
import 'dadata_service.dart';
import 'data/datasources/dadata_remote_data_source.dart';

/// Implementation of DaDataService
class DaDataServiceImpl implements DaDataService {
  final DaDataRemoteDataSource _remoteDataSource;

  DaDataServiceImpl(this._remoteDataSource);

  @override
  Future<Result<List<String>>> getAddressSuggestions(String query) async {
    final result = await _remoteDataSource.getAddressSuggestions(query);
    return result.map(
      (response) => response.suggestions.map((s) => s.value).toList(),
    );
  }

  @override
  Future<Result<List<String>>> getCountrySuggestions(String query) async {
    final result = await _remoteDataSource.getCountrySuggestions(query);
    return result.map(
      (response) => response.suggestions.map((s) => s.value).toList(),
    );
  }

  @override
  Future<Result<List<String>>> getPartySuggestions(String query) async {
    final result = await _remoteDataSource.getPartySuggestions(query);
    return result.map(
      (response) => response.suggestions.map((s) => s.value).toList(),
    );
  }
}
