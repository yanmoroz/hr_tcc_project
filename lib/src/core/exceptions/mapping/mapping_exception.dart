import 'package:equatable/equatable.dart';

class MappingException extends Equatable implements Exception {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const MappingException({required this.message, this.error, this.stackTrace});

  factory MappingException.fromParsingError(
    dynamic error,
    StackTrace? stackTrace,
  ) {
    return MappingException(
      message: 'Failed to parse response data: ${error.toString()}',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  List<Object?> get props => [message, error];

  @override
  String toString() => message;
}
