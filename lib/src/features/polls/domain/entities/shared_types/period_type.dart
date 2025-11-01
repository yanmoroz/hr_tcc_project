enum PeriodType {
  daily,
  weekly,
  monthly,
  yearly;

  int get value {
    switch (this) {
      case PeriodType.daily:
        return 0;
      case PeriodType.weekly:
        return 1;
      case PeriodType.monthly:
        return 2;
      case PeriodType.yearly:
        return 3;
    }
  }

  String get displayName {
    switch (this) {
      case PeriodType.daily:
        return 'Ежедневный';
      case PeriodType.weekly:
        return 'Еженедельный';
      case PeriodType.monthly:
        return 'Ежемесячный';
      case PeriodType.yearly:
        return 'Ежегодный';
    }
  }

  static PeriodType? fromInt(int? value) {
    if (value == null) return null;
    switch (value) {
      case 0:
        return PeriodType.daily;
      case 1:
        return PeriodType.weekly;
      case 2:
        return PeriodType.monthly;
      case 3:
        return PeriodType.yearly;
      default:
        throw ArgumentError('Unknown PeriodType: $value');
    }
  }
}

PeriodType? periodTypeFromJson(int? value) => PeriodType.fromInt(value);
