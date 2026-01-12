import 'package:freezed_annotation/freezed_annotation.dart';

part 'dadata_suggestion_model.freezed.dart';
part 'dadata_suggestion_model.g.dart';

/// A single suggestion from DaData API
@freezed
abstract class DaDataSuggestionModel with _$DaDataSuggestionModel {
  const factory DaDataSuggestionModel({required String value}) =
      _DaDataSuggestionModel;

  factory DaDataSuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$DaDataSuggestionModelFromJson(json);
}

/// Response wrapper containing list of suggestions
@freezed
abstract class DaDataSuggestionsResponseModel
    with _$DaDataSuggestionsResponseModel {
  const factory DaDataSuggestionsResponseModel({
    required List<DaDataSuggestionModel> suggestions,
  }) = _DaDataSuggestionsResponseModel;

  factory DaDataSuggestionsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DaDataSuggestionsResponseModelFromJson(json);
}
