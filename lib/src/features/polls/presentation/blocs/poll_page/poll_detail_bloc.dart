import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/base_types/result.dart';
import '../../../../../core/files/entities/uploaded_file.dart';
import '../../../../../core/files/files_service.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../domain/domain.dart';

import 'poll_detail_event.dart';
import 'poll_detail_state.dart';

class PollDetailBloc extends Bloc<PollDetailEvent, PollDetailState> {
  final int pollId;
  final GetPollDetailUsecase getPollDetailUsecase;
  final SubmitPollAnswersUsecase submitPollAnswersUsecase;
  final GetStaffUsecase getStaffUsecase;
  final FilesService _filesService;

  PollDetailBloc({
    required this.pollId,
    required this.getPollDetailUsecase,
    required this.submitPollAnswersUsecase,
    required this.getStaffUsecase,
    required FilesService filesService,
  }) : _filesService = filesService,
       super(const PollDetailState()) {
    on<PollDetailEvent>((event, emit) async {
      await event.when(
        loadPollDetail: () => _onLoadPollDetail(emit),
        nextPage: () => _onNextPage(emit),
        previousPage: () => _onPreviousPage(emit),
        submitAnswers: (request) => _onSubmitAnswers(request, emit),
        searchStaff: (target, search) => _onSearchStaff(target, search, emit),
      );
    });
  }

  Future<void> _onLoadPollDetail(Emitter<PollDetailState> emit) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await getPollDetailUsecase(pollId);

    await result.fold(
      (error) async => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.message,
        ),
      ),
      (pollDetail) async {
        emit(
          state.copyWith(status: LoadingStatus.success, pollDetail: pollDetail),
        );
        await _loadCoverImage(pollDetail, emit);
      },
    );
  }

  Future<void> _loadCoverImage(
    PollDetail pollDetail,
    Emitter<PollDetailState> emit,
  ) async {
    if (pollDetail.cover.isEmpty) return;

    final result = await _filesService.downloadFile(
      systemType: SystemType.kp,
      download: false,
      uriFile: pollDetail.cover,
    );

    result.fold(
      (error) {
        // Silently fail for cover image download
      },
      (imageBytes) {
        if (state.status == LoadingStatus.success) {
          emit(state.copyWith(coverImage: imageBytes));
        }
      },
    );
  }

  Future<void> _onNextPage(Emitter<PollDetailState> emit) async {
    if (state.pollDetail == null) return;

    final totalPages = state.pollDetail!.pages.length;
    if (state.currentPageIndex < totalPages - 1) {
      emit(state.copyWith(currentPageIndex: state.currentPageIndex + 1));
    }
  }

  Future<void> _onPreviousPage(Emitter<PollDetailState> emit) async {
    if (state.currentPageIndex > 0) {
      emit(state.copyWith(currentPageIndex: state.currentPageIndex - 1));
    }
  }

  Future<void> _onSubmitAnswers(
    List<PollAnswer> answers,
    Emitter<PollDetailState> emit,
  ) async {
    if (state.pollDetail == null) {
      emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: 'Poll detail not loaded yet',
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    final result = await submitPollAnswersUsecase(
      pollId: pollId,
      answers: answers,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.message,
          isSubmitting: false,
        ),
      ),
      (_) => emit(
        state.copyWith(status: LoadingStatus.success, isSubmitting: false),
      ),
    );
  }

  Future<void> _onSearchStaff(
    StaffTarget target,
    String? search,
    Emitter<PollDetailState> emit,
  ) async {
    if (state.pollDetail == null) {
      return;
    }

    emit(state.copyWith(isSearchingStaff: true));

    final result = await getStaffUsecase(target: target, search: search);

    result.fold(
      (error) => emit(
        state.copyWith(
          staffSearchError: error.message,
          isSearchingStaff: false,
        ),
      ),
      (staffItems) => emit(
        state.copyWith(
          staffItems: staffItems,
          isSearchingStaff: false,
          staffSearchError: null,
        ),
      ),
    );
  }

  /// Uploads a file attachment for poll answers.
  Future<Result<UploadedFile>> uploadFile({
    required File file,
    required SystemType systemType,
    required void Function(int sent, int total) onProgress,
  }) {
    return _filesService.uploadFile(
      file: file,
      systemType: systemType,
      onProgress: onProgress,
    );
  }
}
