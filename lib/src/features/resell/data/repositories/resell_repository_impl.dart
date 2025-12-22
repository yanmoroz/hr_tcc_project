import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../../domain/domain.dart';
import '../datasources/resell_remote_data_source.dart';
import '../models/responses/resell_equipment_type_model.dart';

class ResellRepositoryImpl implements ResellRepository {
  final ResellRemoteDataSource _remoteDataSource;

  ResellRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<ResellItemsResult>> getResellItems({
    required ResellStatus status,
    String? search,
    required int page,
    required int pageSize,
  }) async {
    final result = await _remoteDataSource.getResellItems(
      status: status,
      search: search,
      page: page,
      pageSize: pageSize,
    );

    return result.map((response) {
      return (
        items: response.items.map((model) => model.toDomain()).toList(),
        total: response.total,
      );
    });
  }

  @override
  Future<Result<ResellDetail>> getResellDetail(String id) async {
    final result = await _remoteDataSource.getResellDetail(id);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<void>> bookResellItem(String id) async {
    return await _remoteDataSource.bookResellItem(id);
  }

  @override
  Future<Result<void>> confirmBooking({
    required String id,
    required BookingTransition transition,
    String? inn,
    String? address,
    String? employeePlace,
    bool? pickupLotMyself,
  }) async {
    return await _remoteDataSource.confirmBooking(
      id: id,
      transition: transition,
      inn: inn,
      address: address,
      employeePlace: employeePlace,
      pickupLotMyself: pickupLotMyself,
    );
  }

  @override
  Future<Result<List<ResellEquipmentType>>> getResellEquipmentTypes() async {
    final result = await _remoteDataSource.getResellEquipmentTypes();

    return result.map((response) {
      return response.map((model) => model.toDomain()).toList();
    });
  }
}
