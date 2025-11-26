import 'package:intl/intl.dart';

extension IntFormatting on int {
  /// Formats the integer with thousands separators using spaces
  /// Example: 2345 -> '2 345', 1234567 -> '1 234 567'
  String toFormattedString() {
    final formatter = NumberFormat('#,###', 'ru_RU');
    return formatter.format(this);
  }

  /// Formats as compact notation (1.2K, 3.4M, etc.)
  /// Example: 2345 -> '2.3K', 1234567 -> '1.2M'
  String toCompactString() {
    final formatter = NumberFormat.compact(locale: 'ru_RU');
    return formatter.format(this);
  }
}
