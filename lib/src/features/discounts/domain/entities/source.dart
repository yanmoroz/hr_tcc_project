import 'package:freezed_annotation/freezed_annotation.dart';

part 'source.freezed.dart';

@freezed
abstract class Source with _$Source {
  const factory Source({required int id, required String title}) = _Source;
}
