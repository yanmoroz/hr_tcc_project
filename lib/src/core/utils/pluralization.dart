import 'package:intl/intl.dart';

String pluralizeRu(int count, String one, String few, String other) {
  return Intl.plural(count, one: one, few: few, other: other, locale: 'ru');
}
