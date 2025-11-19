import '../../../../core/value_objects/application_status.dart';

class CheckApplicationStatusResult {
  final ApplicationStatus status;
  final String? instance;
  final String? id;
  final String? idApplication;

  CheckApplicationStatusResult({
    required this.status,
    this.instance,
    this.id,
    this.idApplication,
  });
}
