import '../../../../core/entities/system_status.dart';
import '../../../../core/value_objects/application_status.dart';

class CheckCancelStatusResult {
  final ApplicationStatus status;
  final String id;
  final SystemStatus systemStatus;

  CheckCancelStatusResult({
    required this.status,
    required this.id,
    required this.systemStatus,
  });
}
