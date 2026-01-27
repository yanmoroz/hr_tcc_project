import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/base_types/result.dart';
import '../../../../../core/files/files_service.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../domain/domain.dart';

import 'polls_list_event.dart';
import 'polls_list_state.dart';

class PollsListBloc extends Bloc<PollsListEvent, PollsListState> {
  final GetPollsUsecase getPollsUsecase;
  final FilesService filesService;

  PollsListBloc({required this.getPollsUsecase, required this.filesService})
    : super(const PollsListState()) {
    on<LoadPolls>(_onLoadPolls);
    on<LoadMore>(_onLoadMore);
    on<RefreshPolls>(_onRefreshPolls);
    on<FilterByStatus>(_onFilterByStatus);
  }

  Future<void> _onLoadPolls(
    LoadPolls event,
    Emitter<PollsListState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await getPollsUsecase(status: state.currentStatus, page: 0);

    await result.fold(
      (error) async => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.message,
        ),
      ),
      (polls) async {
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            polls: polls,
            currentPage: 0,
            hasMorePages: polls.length >= 20,
          ),
        );
        await _loadCoverImages(polls, emit);
        await _loadTotalCounts(emit);
      },
    );
  }

  Future<void> _onLoadMore(LoadMore event, Emitter<PollsListState> emit) async {
    if (state.isLoadingMore || !state.hasMorePages) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await getPollsUsecase(
      status: state.currentStatus,
      page: nextPage,
    );

    await result.fold(
      (error) async => emit(state.copyWith(isLoadingMore: false)),
      (newPolls) async {
        final updatedPolls = [...state.polls, ...newPolls];
        emit(
          state.copyWith(
            polls: updatedPolls,
            currentPage: nextPage,
            hasMorePages: newPolls.length >= 20,
            isLoadingMore: false,
          ),
        );
        await _loadCoverImages(newPolls, emit);
      },
    );
  }

  Future<void> _onRefreshPolls(
    RefreshPolls event,
    Emitter<PollsListState> emit,
  ) async {
    final result = await getPollsUsecase(status: state.currentStatus, page: 0);

    await result.fold(
      (error) async => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.message,
        ),
      ),
      (polls) async {
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            polls: polls,
            currentPage: 0,
            hasMorePages: polls.length >= 20,
          ),
        );
        await _loadCoverImages(polls, emit);
        await _loadTotalCounts(emit);
      },
    );
  }

  Future<void> _onFilterByStatus(
    FilterByStatus event,
    Emitter<PollsListState> emit,
  ) async {
    emit(
      state.copyWith(
        filteringStatus: LoadingStatus.loading,
        currentStatus: event.status,
      ),
    );

    final result = await getPollsUsecase(status: event.status, page: 0);

    await result.fold(
      (error) async => emit(
        state.copyWith(
          filteringStatus: LoadingStatus.error,
          errorMessage: error.message,
        ),
      ),
      (polls) async {
        emit(
          state.copyWith(
            filteringStatus: LoadingStatus.success,
            status: LoadingStatus.success,
            polls: polls,
            currentPage: 0,
            hasMorePages: polls.length >= 20,
          ),
        );
        await _loadCoverImages(polls, emit);
      },
    );
  }

  Future<void> _loadTotalCounts(Emitter<PollsListState> emit) async {
    // Load counts for all statuses in parallel
    final allResult = await getPollsUsecase(status: null, page: 0);
    final notPassedResult = await getPollsUsecase(status: 1, page: 0);
    final passedResult = await getPollsUsecase(status: 2, page: 0);

    int totalAll = 0;
    int totalNotPassed = 0;
    int totalPassed = 0;

    allResult.fold((error) {}, (polls) => totalAll = polls.length);

    notPassedResult.fold((error) {}, (polls) => totalNotPassed = polls.length);

    passedResult.fold((error) {}, (polls) => totalPassed = polls.length);

    emit(
      state.copyWith(
        totalAll: totalAll,
        totalNotPassed: totalNotPassed,
        totalPassed: totalPassed,
      ),
    );
  }

  Future<void> _loadCoverImages(
    List<Poll> polls,
    Emitter<PollsListState> emit,
  ) async {
    final coverImages = Map<int, Uint8List>.from(state.coverImages);

    // Download images in parallel for polls that have cover
    final futures = polls
        .where((poll) => poll.cover != null && poll.cover!.isNotEmpty)
        .where((poll) => !coverImages.containsKey(poll.id))
        .map((poll) async {
          final result = await filesService.downloadFile(
            systemType: SystemType.kp,
            download: false,
            uriFile: poll.cover!,
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
