enum StatusGroupType {
  active,
  agreement,
  rejected,
  canceled,
  completed;

  String get value {
    switch (this) {
      case StatusGroupType.active:
        return 'active';
      case StatusGroupType.agreement:
        return 'agreement';
      case StatusGroupType.rejected:
        return 'rejected';
      case StatusGroupType.canceled:
        return 'canceled';
      case StatusGroupType.completed:
        return 'completed';
    }
  }

  static StatusGroupType fromString(String value) {
    switch (value) {
      case 'active':
        return StatusGroupType.active;
      case 'agreement':
        return StatusGroupType.agreement;
      case 'rejected':
        return StatusGroupType.rejected;
      case 'canceled':
        return StatusGroupType.canceled;
      case 'completed':
        return StatusGroupType.completed;
      default:
        throw ArgumentError('Unknown StatusGroupType: $value');
    }
  }
}

StatusGroupType statusGroupTypeFromJson(String value) => StatusGroupType.fromString(value);
