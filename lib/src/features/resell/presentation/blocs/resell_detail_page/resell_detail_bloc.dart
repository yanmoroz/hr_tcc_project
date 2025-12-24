import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/cache/image_cache_service.dart';
import '../../../../../core/logging/app_logger.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../domain/domain.dart';

import 'resell_detail_event.dart';
import 'resell_detail_state.dart';

class ResellDetailBloc extends Bloc<ResellDetailEvent, ResellDetailState> {
  final String itemId;
  final GetResellDetailUsecase _getResellDetailUsecase;
  final BookResellItemUsecase _bookResellItemUsecase;
  final ImageCacheService _imageCacheService;

  ResellDetailBloc({
    required this.itemId,
    required GetResellDetailUsecase getResellDetailUsecase,
    required BookResellItemUsecase bookResellItemUsecase,
    required ImageCacheService imageCacheService,
  }) : _getResellDetailUsecase = getResellDetailUsecase,
       _bookResellItemUsecase = bookResellItemUsecase,
       _imageCacheService = imageCacheService,
       super(const ResellDetailState()) {
    on<LoadResellDetail>(_onLoadResellDetail);
    on<BookResellItem>(_onBookResellItem);
  }

  Future<void> _loadCarouselImages(
    ResellDetail detail,
    Emitter<ResellDetailState> emit,
  ) async {
    final carouselImages = <String, Uint8List>{};
    final photoIds = <String>[];

    // Add generalPhoto first if available
    if (detail.generalPhoto != null && detail.generalPhoto!.isNotEmpty) {
      photoIds.add(detail.generalPhoto!);
    }

    // Add all photos from the photo list
    if (detail.photo != null) {
      for (final photoId in detail.photo!) {
        if (!photoIds.contains(photoId)) {
          photoIds.add(photoId);
        }
      }
    }

    final futures = photoIds.map((photoId) async {
      final cached = _imageCacheService.getCached(photoId);
      if (cached != null) {
        carouselImages[photoId] = cached;
        return;
      }

      final imageBytes = await _imageCacheService.getImageById(
        fileId: photoId,
        systemType: SystemType.elma,
      );

      if (imageBytes != null) {
        carouselImages[photoId] = imageBytes;
      }
    });

    await Future.wait(futures);

    if (!emit.isDone && carouselImages.isNotEmpty) {
      emit(state.copyWith(carouselImages: carouselImages));
    }
  }

  Future<void> _onLoadResellDetail(
    LoadResellDetail event,
    Emitter<ResellDetailState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await _getResellDetailUsecase(itemId);

    if (!emit.isDone) {
      await result.fold(
        (error) async {
          AppLogger.e('Failed to load resell detail: ${error.toString()}');
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: error.toString(),
            ),
          );
        },
        (detail) async {
          emit(state.copyWith(status: LoadingStatus.success, detail: detail));
          await _loadCarouselImages(detail, emit);
        },
      );
    }
  }

  Future<void> _onBookResellItem(
    BookResellItem event,
    Emitter<ResellDetailState> emit,
  ) async {
    // Get current detail from state
    if (state.detail == null) return;

    emit(state.copyWith(isBooking: true));

    final result = await _bookResellItemUsecase(itemId);

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to book resell item: ${error.toString()}');
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: error.toString(),
              isBooking: false,
            ),
          );
        },
        (_) {
          AppLogger.d('Booking successful');
          emit(state.copyWith(status: LoadingStatus.success, isBooking: false));
        },
      );
    }
  }
}
