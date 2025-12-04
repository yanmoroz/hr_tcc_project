import 'package:intl/intl.dart';

extension IntFormatting on int {
  String toCompactString() {
    final formatter = NumberFormat.compact(locale: 'ru_RU');
    return formatter.format(this);
  }

  String toFormattedString() {
    final formatter = NumberFormat('#,###', 'ru_RU');
    return formatter.format(this);
  }
}
