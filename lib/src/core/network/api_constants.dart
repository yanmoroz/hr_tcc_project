import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // ==================== Configuration ====================
  static String get baseUrl =>
      "https://dev-memp-hr-tcc-service.stoloto.su/api/v1";

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'accept';
  static const String acceptValue = '*/*';

  // ==================== Keycloak Configuration ====================
  static String get keycloakBaseUrl => dotenv.env['KEYCLOAK_BASE_URL']!;
  static String get keycloakClientId => dotenv.env['KEYCLOAK_CLIENT_ID']!;
  static String get keycloakClientSecret =>
      dotenv.env['KEYCLOAK_CLIENT_SECRET']!;

  // ==================== Keycloak Endpoints ====================
  static const String keycloakTokenEndpoint =
      '/realms/tccenter/protocol/openid-connect/token';

  // ==================== Application Endpoints ====================
  static const String applicationsEndpoint = '/applications';
  static const String checkApplicationStatusEndpoint = '/applications/check';

  static String applicationDetailEndpoint(String id) => '/applications/$id';
  static String cancelApplicationEndpoint(String id) =>
      '/applications/$id/cancel';
  static String checkCancelStatusEndpoint(String id) =>
      '/applications/$id/cancel-check';

  // ==================== Dictionary Endpoints ====================
  static const String coreDictionariesEndpoint = '/dictionaries';
  static const String kpAbsenceCategoryEndpoint =
      '/dictionaries/absence-category';
  static const String businessTripPurposeEndpoint =
      '/dictionaries/business-trip-purpose';
  static const String kpDiscountCategoryEndpoint =
      '/dictionaries/discount-category';
  static const String kpDiscountSourceEndpoint =
      '/dictionaries/discount-source';
  static const String kpNewsCategoryEndpoint = '/dictionaries/news-category';
  static const String kpOfficeEndpoint = '/dictionaries/offices-kp';
  static const String kpParkingTypeEndpoint = '/dictionaries/parking-type';
  static const String referralProgramCandidateEndpoint =
      '/dictionaries/referral-program-candidate';
  static const String referralProgramVacancyEndpoint =
      '/dictionaries/referral-program-vacation';
  static const String resellEquipmentTypeEndpoint =
      '/dictionaries/resell-equipment-type';
  static const String unplannedTrainingContractorEndpoint =
      '/dictionaries/unplanned-training-contractor';
  static const String violationSecurityLevelEndpoint =
      '/dictionaries/violation-security-level';

  // ==================== Discount Endpoints ====================
  static const String discountsEndpoint = '/discount';

  static String discountDetailEndpoint(int id) => '/discount/$id';
  static String discountLikeEndpoint(int id) => '/discount/$id/likes';
  static String discountStatsEndpoint(int id) =>
      '/discount/$id/comment-and-like-count';
  static String discountCommentsEndpoint(int discountId) =>
      '/discount/$discountId/comments';
  static String discountCommentEndpoint(int discountId, int commentId) =>
      '/discount/comments/$commentId';
  static String commentLikeEndpoint(int discountId, int commentId) =>
      '/discount/comments/$commentId/likes';

  // ==================== File Endpoints ====================
  static const String filesUploadEndpoint = '/files/upload';
  static const String filesDownloadEndpoint = '/files/download';

  // ==================== News Endpoints ====================
  static const String newsEndpoint = '/news';

  static String newsDetailEndpoint(int id) => '/news/$id';
  static String newsLikeEndpoint(int id) => '/news/$id/likes';
  static String newsStatsEndpoint(int id) => '/news/$id/comment-and-like-count';
  static String newsCommentsEndpoint(int newsId) => '/news/$newsId/comments';
  static String newsCommentEndpoint(int newsId, int commentId) =>
      '/news/comments/$commentId';
  static String newsCommentLikeEndpoint(int newsId, int commentId) =>
      '/news/comments/$commentId/likes';
  static String newsGalleryEndpoint(int galleryId) =>
      '/news/gallery/$galleryId';

  // ==================== Notification Endpoints ====================
  static const String notificationsEndpoint = '/notifications';
  static const String notificationsCountEndpoint = '/notifications/count';
  static const String notificationsReadEndpoint = '/notifications/read';

  // ==================== Poll Endpoints ====================
  static const String pollsEndpoint = '/polls';
  static const String staffEndpoint = '/polls/staff';

  static String pollDetailEndpoint(int pollId) => '/polls/$pollId';
  static String pollVoteEndpoint(int pollId) => '/polls/$pollId/vote';

  // ==================== Resell Endpoints ====================
  static const String resellListEndpoint = '/resell';

  static String resellDetailEndpoint(String id) => '/resell/$id';
  static String resellBookingEndpoint(String id) => '/resell/$id/booking';
  static String resellConfirmBookingEndpoint(String id) =>
      '/resell/$id/confirm-booking';

  // ==================== User Endpoints ====================
  static const String usersEndpoint = '/users';
  static const String currentUserEndpoint = '/users/me';
  static const String addressBookEndpoint = '/users/addressbook';
}
