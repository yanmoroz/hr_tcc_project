import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL']!;

  // Dictionary endpoints
  static const String violationSecurityLevelEndpoint = '/dictionaries/violation-security-level';
  static const String unplannedTrainingContractorEndpoint = '/dictionaries/unplanned-training-contractor';
  static const String resellEquipmentTypeEndpoint = '/dictionaries/resell-equipment-type';
  static const String referralProgramCandidateEndpoint = '/dictionaries/referral-program-candidate';
  static const String referralProgramVacancyEndpoint = '/dictionaries/referral-program-vacation';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'accept';
  static const String acceptValue = '*/*';
}
