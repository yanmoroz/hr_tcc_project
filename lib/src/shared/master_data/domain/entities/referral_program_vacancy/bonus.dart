import 'package:freezed_annotation/freezed_annotation.dart';

part 'bonus.freezed.dart';

@freezed
abstract class Bonus with _$Bonus {
  const factory Bonus({required int cents, required String currency}) = _Bonus;
}
