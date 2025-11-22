import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/base_types/result.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../../../shared/files/domain/domain.dart';
import '../../../domain/domain.dart';

import 'polls_list_event.dart';
import 'polls_list_state.dart';

class PollsListBloc extends Bloc<PollsListEvent, PollsListState> {
  final GetPollsUsecase getPollsUsecase;
  final DownloadFileUsecase downloadFileUsecase;

  PollsListBloc({
    required this.getPollsUsecase,
    required this.downloadFileUsecase,
  }) : super(const PollsListState()) {
    on<PollsListEvent>((event, emit) async {
      await event.when(
        loadPolls: (status) => _onLoadPolls(status, emit),
        refreshPolls: (status) => _onRefreshPolls(status, emit),
      );
    });
  }

  Future<void> _onLoadPolls(int? status, Emitter<PollsListState> emit) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await getPollsUsecase(status: status, page: 1);

    await result.fold(
      (error) async => emit(state.copyWith(
        status: LoadingStatus.error,
        errorMessage: error.message,
      )),
      (polls) async {
        emit(state.copyWith(
          status: LoadingStatus.success,
          polls: polls,
        ));
        await _loadCoverImages(polls, emit);
      },
    );
  }

  Future<void> _onRefreshPolls(
    int? status,
    Emitter<PollsListState> emit,
  ) async {
    // Keep showing current polls while refreshing
    if (state.status == LoadingStatus.success) {
      emit(state.copyWith(
        polls: state.polls,
        coverImages: state.coverImages,
      ));
    }

    final result = await getPollsUsecase(status: status, page: 1);

    await result.fold(
      (error) async => emit(state.copyWith(
        status: LoadingStatus.error,
        errorMessage: error.message,
      )),
      (polls) async {
        emit(state.copyWith(
          status: LoadingStatus.success,
          polls: polls,
        ));
        await _loadCoverImages(polls, emit);
      },
    );
  }

  Future<void> _loadCoverImages(
    List<dynamic> polls,
    Emitter<PollsListState> emit,
  ) async {
    final coverImages = <int, Uint8List>{};

    // Download images in parallel for polls that have cover
    final futures = polls
        .where((poll) => poll.cover != null && poll.cover!.isNotEmpty)
        .map((poll) async {
          final result = await downloadFileUsecase(
            systemType: SystemType.kp,
            download: false,
            uriFile: poll.cover,
          );

          result.fold(
            (error) {
              // Silently fail for individual image downloads
            },
            (imageBytes) {
              coverImages[poll.id] = imageBytes;
            },
          );
        });

    await Future.wait(futures);

    // Emit updated state with cover images
    if (state.status == LoadingStatus.success) {
      emit(state.copyWith(coverImages: coverImages));
    }
  }
}
