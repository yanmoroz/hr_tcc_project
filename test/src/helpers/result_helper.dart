import 'package:flutter_test/flutter_test.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';

Future<T> getOrFail<T>(Future<Result<T>> result) async {
  final value = await result;
  return value.fold(
    (failure) => fail('Unexpected error: ${failure.message}'),
    (data) => data,
  );
}
