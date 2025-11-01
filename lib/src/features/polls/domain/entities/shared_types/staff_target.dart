enum StaffTarget {
  employee,
  department,
  organisation;

  String get value {
    switch (this) {
      case StaffTarget.employee:
        return 'EMPLOYEE';
      case StaffTarget.department:
        return 'DEPARTMENT';
      case StaffTarget.organisation:
        return 'ORGANISATION';
    }
  }

  String get displayName {
    switch (this) {
      case StaffTarget.employee:
        return 'Сотрудник';
      case StaffTarget.department:
        return 'Отдел';
      case StaffTarget.organisation:
        return 'Организация';
    }
  }

  static StaffTarget fromString(String value) {
    switch (value.toUpperCase()) {
      case 'EMPLOYEE':
        return StaffTarget.employee;
      case 'DEPARTMENT':
        return StaffTarget.department;
      case 'ORGANISATION':
        return StaffTarget.organisation;
      default:
        throw ArgumentError('Unknown StaffTarget: $value');
    }
  }
}

StaffTarget staffTargetFromJson(String value) => StaffTarget.fromString(value);
