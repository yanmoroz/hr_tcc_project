import '../../../../core/entities/system_status.dart';
import '../../../../core/value_objects/application_status.dart';

class CancelApplicationResult {
  final ApplicationStatus status;
  final String id;
  final SystemStatus systemStatus;

  CancelApplicationResult({
    required this.status,
    required this.id,
    required this.systemStatus,
  });
}
