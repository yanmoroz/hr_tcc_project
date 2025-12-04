TccImageDestinationType tccImageDestinationTypeFromJson(String value) =>
    TccImageDestinationType.fromString(value);

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
