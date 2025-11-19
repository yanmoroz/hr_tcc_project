enum QuestionType {
  multiLineText,
  choice,
  tableLookup,
  dropdown,
  scale,
  attachment;

  int get value {
    switch (this) {
      case QuestionType.multiLineText:
        return 0;
      case QuestionType.choice:
        return 1;
      case QuestionType.tableLookup:
        return 2;
      case QuestionType.dropdown:
        return 3;
      case QuestionType.scale:
        return 4;
      case QuestionType.attachment:
        return 5;
    }
  }

  String get displayName {
    switch (this) {
      case QuestionType.multiLineText:
        return 'Многострочный текст';
      case QuestionType.choice:
        return 'Выбор';
      case QuestionType.tableLookup:
        return 'Подстановка из таблицы';
      case QuestionType.dropdown:
        return 'Выбор из выпадающего списка';
      case QuestionType.scale:
        return 'Шкала оценок';
      case QuestionType.attachment:
        return 'Вложения';
    }
  }

  static QuestionType fromInt(int value) {
    switch (value) {
      case 0:
        return QuestionType.multiLineText;
      case 1:
        return QuestionType.choice;
      case 2:
        return QuestionType.tableLookup;
      case 3:
        return QuestionType.dropdown;
      case 4:
        return QuestionType.scale;
      case 5:
        return QuestionType.attachment;
      default:
        throw ArgumentError('Unknown QuestionType: $value');
    }
  }
}

QuestionType questionTypeFromJson(int value) => QuestionType.fromInt(value);
