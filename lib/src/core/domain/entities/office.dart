import 'package:freezed_annotation/freezed_annotation.dart';

part 'office.freezed.dart';

@freezed
abstract class Office with _$Office {
  const factory Office({
    required String id,
    required String code,
    required String name,
  }) = _Office;
}
