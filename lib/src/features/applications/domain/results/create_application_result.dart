import '../../../../core/value_objects/application_status.dart';

class CreateApplicationResult {
  final ApplicationStatus status;
  final String? instance;
  final String? id;
  final String? idApplication;

  CreateApplicationResult({
    required this.status,
    this.instance,
    this.id,
    this.idApplication,
  });
}
