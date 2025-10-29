import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';

abstract class CoreDictionariesRepository {
  Future<Either<NetworkException, List<ApplicationFormGroup>>> getApplicationFormGroups();
  Future<Either<NetworkException, List<ApplicationForm>>> getApplicationForms();
  Future<Either<NetworkException, List<SystemStatusGroup>>> getSystemStatusGroups();
  Future<Either<NetworkException, List<SystemStatus>>> getSystemStatuses();
  Future<Either<NetworkException, List<TripPurpose>>> getTripPurposes();
  Future<Either<NetworkException, List<TrainingType>>> getTrainingTypes();
  Future<Either<NetworkException, List<TrainingForm>>> getTrainingForms();
  Future<Either<NetworkException, List<TrainingMonth>>> getTrainingMonths();
  Future<Either<NetworkException, List<AlpinaDigitalPrevAccess>>> getAlpinaDigitalPrevAccess();
  Future<Either<NetworkException, List<Office>>> getOffices();
}
