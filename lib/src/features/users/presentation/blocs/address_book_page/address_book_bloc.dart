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

    final result = await _getAddressBookUsecase(
      organizationCode: null,
      departmentCode: null,
      search: event.search,
      page: 0,
      pageSize: _pageSize,
    );

    result.fold(
      (error) => emit(state.copyWith(
        status: LoadingStatus.error,
        errorMessage: error.toString(),
      )),
      (users) => emit(state.copyWith(
        status: LoadingStatus.success,
        users: users,
        currentPage: 0,
        hasMorePages: users.length >= _pageSize,
        isLoadingMore: false,
        searchQuery: event.search,
      )),
    );
  }

  Future<void> _onRefreshAddressBook(
    RefreshAddressBook event,
    Emitter<AddressBookState> emit,
  ) async {
    final searchQuery = state.searchQuery;

    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await _getAddressBookUsecase(
      organizationCode: null,
      departmentCode: null,
      search: searchQuery,
      page: 0,
      pageSize: _pageSize,
    );

    result.fold(
      (error) => emit(state.copyWith(
        status: LoadingStatus.error,
        errorMessage: error.toString(),
      )),
      (users) => emit(state.copyWith(
        status: LoadingStatus.success,
        users: users,
        currentPage: 0,
        hasMorePages: users.length >= _pageSize,
        isLoadingMore: false,
        searchQuery: searchQuery,
      )),
    );
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
      (newUsers) => emit(state.copyWith(
        users: [...state.users, ...newUsers],
        currentPage: nextPage,
        hasMorePages: newUsers.length >= _pageSize,
        isLoadingMore: false,
      )),
    );
  }

  Future<void> _onSearchAddressBook(
    SearchAddressBook event,
    Emitter<AddressBookState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final searchQuery = event.query.trim().isEmpty ? null : event.query.trim();

    final result = await _getAddressBookUsecase(
      organizationCode: null,
      departmentCode: null,
      search: searchQuery,
      page: 0,
      pageSize: _pageSize,
    );

    result.fold(
      (error) => emit(state.copyWith(
        status: LoadingStatus.error,
        errorMessage: error.toString(),
      )),
      (users) => emit(state.copyWith(
        status: LoadingStatus.success,
        users: users,
        currentPage: 0,
        hasMorePages: users.length >= _pageSize,
        isLoadingMore: false,
        searchQuery: searchQuery,
      )),
    );
  }
}
