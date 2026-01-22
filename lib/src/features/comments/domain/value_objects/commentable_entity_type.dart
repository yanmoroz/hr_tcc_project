enum CommentableEntityType {
  news,
  discount;

  String get value {
    switch (this) {
      case CommentableEntityType.news:
        return 'news';
      case CommentableEntityType.discount:
        return 'discount';
    }
  }

  static CommentableEntityType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'news':
        return CommentableEntityType.news;
      case 'discount':
        return CommentableEntityType.discount;
      default:
        throw ArgumentError('Unknown CommentableEntityType: $value');
    }
  }
}
