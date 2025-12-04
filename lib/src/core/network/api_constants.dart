import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Dictionary endpoints
  static const String coreDictionariesEndpoint = '/dictionaries';

  static const String violationSecurityLevelEndpoint =
      '/dictionaries/violation-security-level';
  static const String unplannedTrainingContractorEndpoint =
      '/dictionaries/unplanned-training-contractor';
  static const String resellEquipmentTypeEndpoint =
      '/dictionaries/resell-equipment-type';
  static const String referralProgramCandidateEndpoint =
      '/dictionaries/referral-program-candidate';
  static const String referralProgramVacancyEndpoint =
      '/dictionaries/referral-program-vacation';
  static const String kpNewsCategoryEndpoint = '/dictionaries/news-category';
  static const String kpDiscountSourceEndpoint =
      '/dictionaries/discount-source';
  static const String kpDiscountCategoryEndpoint =
      '/dictionaries/discount-category';
  static const String kpAbsenceCategoryEndpoint =
      '/dictionaries/absence-category';
  static const String kpOfficeEndpoint = '/dictionaries/offices-kp';
  static const String kpParkingTypeEndpoint = '/dictionaries/parking-type';
  static const String businessTripPurposeEndpoint =
      '/dictionaries/business-trip-purpose';
  // Notification endpoints
  static const String notificationsEndpoint = '/notifications';

  static const String notificationsCountEndpoint = '/notifications/count';
  static const String notificationsReadEndpoint = '/notifications/read';
  // Poll endpoints
  static const String pollsEndpoint = '/polls';

  static const String staffEndpoint = '/polls/staff';
  // File endpoints
  static const String filesUploadEndpoint = '/files/upload';
  static const String filesDownloadEndpoint = '/files/download';
  // User endpoints
  static const String usersEndpoint = '/users';

  static const String addressBookEndpoint = '/users/addressbook';
  static const String currentUserEndpoint = '/users/me';

  // Discount endpoints
  static const String discountsEndpoint = '/discount';
  // News endpoints
  static const String newsEndpoint = '/news';
  // Resell endpoints
  static const String resellListEndpoint = '/resell';

  // Application endpoints
  static const String applicationsEndpoint = '/applications';
  static const String checkApplicationStatusEndpoint = '/applications/check';
  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'accept';
  static const String acceptValue = '*/*';
  static String get baseUrl => dotenv.env['API_BASE_URL']!;
  static String applicationDetailEndpoint(String id) => '/applications/$id';

  static String cancelApplicationEndpoint(String id) =>
      '/applications/$id/cancel';
  static String checkCancelStatusEndpoint(String id) =>
      '/applications/$id/cancel-check';
  static String commentLikeEndpoint(int discountId, int commentId) =>
      '/discount/comments/$commentId/likes';
  static String discountCommentEndpoint(int discountId, int commentId) =>
      '/discount/comments/$commentId';
  static String discountCommentsEndpoint(int discountId) =>
      '/discount/$discountId/comments';
  static String discountDetailEndpoint(int id) => '/discount/$id';
  static String discountLikeEndpoint(int id) => '/discount/$id/likes';
  static String discountStatsEndpoint(int id) =>
      '/discount/$id/comment-and-like-count';

  static String newsCommentEndpoint(int newsId, int commentId) =>
      '/news/comments/$commentId';
  static String newsCommentLikeEndpoint(int newsId, int commentId) =>
      '/news/comments/$commentId/likes';
  static String newsCommentsEndpoint(int newsId) => '/news/$newsId/comments';
  static String newsDetailEndpoint(int id) => '/news/$id';

  static String newsGalleryEndpoint(int galleryId) =>
      '/news/gallery/$galleryId';
  static String newsLikeEndpoint(int id) => '/news/$id/likes';
  static String newsStatsEndpoint(int id) => '/news/$id/comment-and-like-count';
  static String pollDetailEndpoint(int pollId) => '/polls/$pollId';
  static String pollVoteEndpoint(int pollId) => '/polls/$pollId/vote';

  static String resellBookingEndpoint(String id) => '/resell/$id/booking';
  static String resellConfirmBookingEndpoint(String id) =>
      '/resell/$id/confirm-booking';
  static String resellDetailEndpoint(String id) => '/resell/$id';
}
