import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';
import 'department_model.dart';
import 'organization_model.dart';

part 'address_book_user_model.freezed.dart';
part 'address_book_user_model.g.dart';

@freezed
abstract class AddressBookUserModel with _$AddressBookUserModel {
  const factory AddressBookUserModel({
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
    required OrganizationModel organization,
    required DepartmentModel department,
    String? idPersonElma,
    int? idPersonKp,
    String? jiraCode,
    int? vacationDaysLeft,
    required bool archive,
    required bool photoExists,
  }) = _AddressBookUserModel;

  factory AddressBookUserModel.fromJson(Map<String, dynamic> json) =>
      _$AddressBookUserModelFromJson(json);
}

extension AddressBookUserModelX on AddressBookUserModel {
  AddressBookUser toDomain() => AddressBookUser(
    id: id,
    login: login,
    title: title,
    firstName: firstName,
    middleName: middleName,
    lastName: lastName,
    snils: snils,
    birthDate: birthDate,
    mobile: mobile,
    workPhone: workPhone,
    mail: mail,
    workLocation: workLocation,
    position: position,
    organization: organization.toDomain(),
    department: department.toDomain(),
    idPersonElma: idPersonElma,
    idPersonKp: idPersonKp,
    jiraCode: jiraCode,
    vacationDaysLeft: vacationDaysLeft,
    archive: archive,
    photoExists: photoExists,
  );
}
