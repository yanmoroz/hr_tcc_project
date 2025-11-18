import '../../../base_types/result.dart';
import '../models/core_dictionaries_response_model.dart';

abstract class DictionariesRemoteDataSource {
  Future<Result<CoreDictionariesResponseModel>> fetchAllCoreDictionaries();
}
