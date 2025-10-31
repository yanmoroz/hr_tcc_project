enum EntityType {
  discount,
  notify,
  notifyDocument,
  news;

  String get value {
    switch (this) {
      case EntityType.discount:
        return 'DISCOUNT';
      case EntityType.notify:
        return 'NOTIFY';
      case EntityType.notifyDocument:
        return 'NOTIFY_DOCUMENT';
      case EntityType.news:
        return 'NEWS';
    }
  }

  static EntityType fromString(String value) {
    switch (value) {
      case 'DISCOUNT':
        return EntityType.discount;
      case 'NOTIFY':
        return EntityType.notify;
      case 'NOTIFY_DOCUMENT':
        return EntityType.notifyDocument;
      case 'NEWS':
        return EntityType.news;
      default:
        throw ArgumentError('Unknown EntityType: $value');
    }
  }
}

EntityType entityTypeFromJson(String value) => EntityType.fromString(value);
String entityTypeToJson(EntityType entityType) => entityType.value;
