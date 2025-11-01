enum EntityType {
  discount,
  notify,
  notifyDocument,
  news,
  comment,
  post,
  photoAlbum,
  photo,
  congratulations,
  gratitude;

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
      case EntityType.comment:
        return 'COMMENT';
      case EntityType.post:
        return 'POST';
      case EntityType.photoAlbum:
        return 'PHOTO_ALBUM';
      case EntityType.photo:
        return 'PHOTO';
      case EntityType.congratulations:
        return 'CONGRATULATION';
      case EntityType.gratitude:
        return 'GRATITUDE';
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
      case 'COMMENT':
        return EntityType.comment;
      case 'POST':
        return EntityType.post;
      case 'PHOTO_ALBUM':
        return EntityType.photoAlbum;
      case 'PHOTO':
        return EntityType.photo;
      case 'CONGRATULATION':
        return EntityType.congratulations;
      case 'GRATITUDE':
        return EntityType.gratitude;
      default:
        throw ArgumentError('Unknown EntityType: $value');
    }
  }
}

EntityType entityTypeFromJson(String value) => EntityType.fromString(value);
