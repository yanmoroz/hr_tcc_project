/// Constants for DaData API integration
class DaDataConstants {
  // Base URL
  static const String baseUrl = 'https://suggestions.dadata.ru/suggestions/api';

  // API version
  static const String apiVersion = '4_1';

  // Endpoints
  static const String addressSuggestionsEndpoint =
      '/$apiVersion/rs/suggest/address';
  static const String partySuggestionsEndpoint =
      '/$apiVersion/rs/suggest/party';
  static const String countrySuggestionsEndpoint =
      '/$apiVersion/rs/suggest/country';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String secretHeader = 'X-Secret';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String jsonContentType = 'application/json';
}
