TccImageDestinationType tccImageDestinationTypeFromJson(String value) =>
    TccImageDestinationType.fromString(value);

/// TCC image destination type enumeration for file operations
/// Represents where the image/file will be stored in the TCC system
enum TccImageDestinationType {
  applicationForm,
  person;

  String get name {
    switch (this) {
      case TccImageDestinationType.applicationForm:
        return 'Справочник форм заявок';
      case TccImageDestinationType.person:
        return 'Фото сотрудника';
    }
  }

  String get value {
    switch (this) {
      case TccImageDestinationType.applicationForm:
        return 'DICT_APPLICATION_FORM';
      case TccImageDestinationType.person:
        return 'PERSON';
    }
  }

  static TccImageDestinationType fromString(String value) {
    switch (value) {
      case 'DICT_APPLICATION_FORM':
        return TccImageDestinationType.applicationForm;
      case 'PERSON':
        return TccImageDestinationType.person;
      default:
        throw ArgumentError('Unknown TccImageDestinationType: $value');
    }
  }
}
