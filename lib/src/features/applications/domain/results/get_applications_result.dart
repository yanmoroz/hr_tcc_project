import '../entities/application_info.dart';
import '../entities/application_statistics.dart';

class GetApplicationsResult {
  final List<ApplicationInfo> applications;
  final int total;
  final List<ApplicationStatistics> statistics;

  GetApplicationsResult({
    required this.applications,
    required this.total,
    required this.statistics,
  });
}
