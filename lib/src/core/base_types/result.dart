import 'package:fpdart/fpdart.dart';

import '../exceptions/mapping/mapping_exception.dart';
import '../exceptions/network/network_exception.dart';

typedef Result<T> = Either<Exception, T>;

extension ExceptionMessage on Exception {
  String get message {
    final exception = this;
    if (exception is NetworkException) {
      return exception.message;
    } else if (exception is MappingException) {
      return exception.message;
    } else {
      return exception.toString();
    }
  }
}
