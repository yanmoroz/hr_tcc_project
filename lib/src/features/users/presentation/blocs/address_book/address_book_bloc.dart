import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

import 'address_book_event.dart';
import 'address_book_state.dart';

class AddressBookBloc extends Bloc<AddressBookEvent, AddressBookState> {
  AddressBookBloc({required GetAddressBookUsecase getAddressBookUsecase})
    : _getAddressBookUsecase = getAddressBookUsecase,
      super(const AddressBookState()) {
    on<LoadAddressBook>(_onLoadAddressBook);
    on<RefreshAddressBook>(_onRefreshAddressBook);
    on<LoadMoreAddressBook>(_onLoadMoreAddressBook);
    on<SearchAddressBook>(_onSearchAddressBook);
  }

  final GetAddressBookUsecase _getAddressBookUsecase;
  static const int _pageSize = 20;

  Future<void> _onLoadAddressBook(
    LoadAddressBook event,
    Emitter<AddressBookState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadAddressBook(emit, page: 0, search: event.search);
  }

  Future<void> _onRefreshAddressBook(
    RefreshAddressBook event,
    Emitter<AddressBookState> emit,
  ) async {
    await _loadAddressBook(emit, page: 0, search: state.searchQuery);
  }

  Future<void> _onLoadMoreAddressBook(
    LoadMoreAddressBook event,
    Emitter<AddressBookState> emit,
  ) async {
    if (state.status != LoadingStatus.success ||
        state.isLoadingMore ||
        !state.hasMorePages) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await _getAddressBookUsecase(
      organizationCode: null,
      departmentCode: null,
      search: state.searchQuery,
      page: nextPage,
      pageSize: _pageSize,
    );

    result.fold(
      (error) => emit(state.copyWith(isLoadingMore: false)),
      (newUsers) => emit(
        state.copyWith(
          users: [...state.users, ...newUsers],
          currentPage: nextPage,
          hasMorePages: newUsers.length >= _pageSize,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<void> _onSearchAddressBook(
    SearchAddressBook event,
    Emitter<AddressBookState> emit,
  ) async {
    final query = event.query.trim();
    final search = query.isEmpty ? null : query;

    emit(state.copyWith(filteringStatus: LoadingStatus.loading));
    await _loadAddressBook(emit, page: 0, search: search);
  }

  Future<void> _loadAddressBook(
    Emitter<AddressBookState> emit, {
    required int page,
    String? search,
  }) async {
    final result = await _getAddressBookUsecase(
      organizationCode: null,
      departmentCode: null,
      search: search,
      page: page,
      pageSize: _pageSize,
    );

    final isFiltering = state.filteringStatus == LoadingStatus.loading;

    result.fold(
      (error) {
        if (isFiltering) {
          emit(
            state.copyWith(
              filteringStatus: LoadingStatus.error,
              errorMessage: error.toString(),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: error.toString(),
            ),
          );
        }
      },
      (users) {
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            filteringStatus: LoadingStatus.initial,
            users: users,
            currentPage: page,
            hasMorePages: users.length >= _pageSize,
            isLoadingMore: false,
            searchQuery: search,
          ),
        );
      },
    );
  }
}
