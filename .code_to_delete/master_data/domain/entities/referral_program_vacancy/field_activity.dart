import 'package:freezed_annotation/freezed_annotation.dart';

part 'field_activity.freezed.dart';

@freezed
abstract class FieldActivity with _$FieldActivity {
  const factory FieldActivity({required String code, required String name}) = _FieldActivity;
}


