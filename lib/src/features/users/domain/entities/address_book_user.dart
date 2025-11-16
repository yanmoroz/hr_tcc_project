import 'package:freezed_annotation/freezed_annotation.dart';

import 'department.dart';
import 'organization.dart';

part 'address_book_user.freezed.dart';

@freezed
abstract class AddressBookUser with _$AddressBookUser {
  const factory AddressBookUser({
    required String id,
    required String login,
    required String title,
    required String firstName,
    String? middleName,
    required String lastName,
    required String snils,
    required DateTime birthDate,
    required String mobile,
    String? workPhone,
    required String mail,
    String? workLocation,
    String? position,
    required Organization organization,
    required Department department,
    String? idPersonElma,
    int? idPersonKp,
    String? jiraCode,
    int? vacationDaysLeft,
    required bool archive,
    required bool photoExists,
  }) = _AddressBookUser;
}
