SystemType systemTypeFromJson(String value) => SystemType.fromString(value);

/// System type enumeration for file operations
enum SystemType {
  elma,
  kp,
  jira,
  tcc,
  oneC;

  String get value {
    switch (this) {
      case SystemType.elma:
        return 'ELMA';
      case SystemType.kp:
        return 'KP';
      case SystemType.jira:
        return 'JIRA';
      case SystemType.tcc:
        return 'TCC';
      case SystemType.oneC:
        return '_1C';
    }
  }

  static SystemType fromString(String value) {
    switch (value) {
      case 'ELMA':
        return SystemType.elma;
      case 'KP':
        return SystemType.kp;
      case 'JIRA':
        return SystemType.jira;
      case 'TCC':
        return SystemType.tcc;
      case '_1C':
        return SystemType.oneC;
      default:
        throw ArgumentError('Unknown SystemType: $value');
    }
  }
}
