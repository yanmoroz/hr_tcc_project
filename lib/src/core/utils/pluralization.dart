import 'package:intl/intl.dart';

/// Russian pluralization helper using intl package.
/// Automatically handles Russian plural rules (one, few, other).
String pluralizeRu(int count, String one, String few, String other) {
  return Intl.plural(count, one: one, few: few, other: other, locale: 'ru');
}
