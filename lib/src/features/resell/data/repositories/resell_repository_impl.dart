import 'package:hr_tcc_project/src/core/types/result.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';

import '../datasources/resell_remote_data_source.dart';
import '../models/resell_booking_confirmation_model.dart';

class ResellRepositoryImpl implements ResellRepository {
  final ResellRemoteDataSource _remoteDataSource;

  ResellRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ResellItem>>> getResellItems({
    required int status,
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
      return response.items.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<Result<ResellDetail>> getResellDetail(String id) async {
    final result = await _remoteDataSource.getResellDetail(id);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<ResellBooking>> bookResellItem(String id) async {
    final result = await _remoteDataSource.bookResellItem(id);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<ResellBookingConfirm>> confirmBooking({
    required String id,
    required ResellBookingConfirmation confirmation,
  }) async {
    final confirmationModel = confirmation.toModel();
    final result = await _remoteDataSource.confirmBooking(id: id, confirmation: confirmationModel);
    return result.map((model) => model.toDomain());
  }
}
