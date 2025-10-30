import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL']!;

  // Dictionary endpoints
  static const String violationSecurityLevelEndpoint = '/dictionaries/violation-security-level';
  static const String unplannedTrainingContractorEndpoint = '/dictionaries/unplanned-training-contractor';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'accept';
  static const String acceptValue = '*/*';
}
