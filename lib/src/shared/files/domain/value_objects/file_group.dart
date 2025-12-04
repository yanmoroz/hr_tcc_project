FileGroup? fileGroupFromJson(String? value) => FileGroup.fromString(value);

enum FileGroup {
  news,
  discount,
  pass;

  String get value {
    switch (this) {
      case FileGroup.news:
        return 'NEWS';
      case FileGroup.discount:
        return 'DISCOUNT';
      case FileGroup.pass:
        return 'PASS';
    }
  }

  static FileGroup? fromString(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'NEWS':
        return FileGroup.news;
      case 'DISCOUNT':
        return FileGroup.discount;
      case 'PASS':
        return FileGroup.pass;
      default:
        return null;
    }
  }
}
