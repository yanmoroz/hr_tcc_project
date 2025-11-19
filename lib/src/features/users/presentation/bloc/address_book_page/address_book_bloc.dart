import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

import 'address_book_event.dart';
import 'address_book_state.dart';

class AddressBookBloc extends Bloc<AddressBookEvent, AddressBookState> {
  AddressBookBloc({required GetAddressBookUsecase getAddressBookUsecase})
    : _getAddressBookUsecase = getAddressBookUsecase,
      super(const AddressBookState.initial()) {
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
    emit(const AddressBookState.loading());

    final result = await _getAddressBookUsecase(
      organizationCode: null,
      departmentCode: null,
      search: event.search,
      page: 0,
      pageSize: _pageSize,
    );

    result.fold(
      (error) => emit(AddressBookState.error(error.toString())),
      (users) => emit(
        AddressBookState.loaded(
          users: users,
          currentPage: 0,
          hasMorePages: users.length >= _pageSize,
          isLoadingMore: false,
          searchQuery: event.search,
        ),
      ),
    );
  }

  Future<void> _onRefreshAddressBook(
    RefreshAddressBook event,
    Emitter<AddressBookState> emit,
  ) async {
    final currentState = state;
    String? searchQuery;

    if (currentState is AddressBookLoaded) {
      searchQuery = currentState.searchQuery;
    }

    emit(const AddressBookState.loading());

    final result = await _getAddressBookUsecase(
      organizationCode: null,
      departmentCode: null,
      search: searchQuery,
      page: 0,
      pageSize: _pageSize,
    );

    result.fold(
      (error) => emit(AddressBookState.error(error.toString())),
      (users) => emit(
        AddressBookState.loaded(
          users: users,
          currentPage: 0,
          hasMorePages: users.length >= _pageSize,
          isLoadingMore: false,
          searchQuery: searchQuery,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreAddressBook(
    LoadMoreAddressBook event,
    Emitter<AddressBookState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AddressBookLoaded) return;
    if (currentState.isLoadingMore || !currentState.hasMorePages) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await _getAddressBookUsecase(
      organizationCode: null,
      departmentCode: null,
      search: currentState.searchQuery,
      page: nextPage,
      pageSize: _pageSize,
    );

    result.fold(
      (error) => emit(currentState.copyWith(isLoadingMore: false)),
      (newUsers) => emit(
        AddressBookState.loaded(
          users: [...currentState.users, ...newUsers],
          currentPage: nextPage,
          hasMorePages: newUsers.length >= _pageSize,
          isLoadingMore: false,
          searchQuery: currentState.searchQuery,
        ),
      ),
    );
  }

  Future<void> _onSearchAddressBook(
    SearchAddressBook event,
    Emitter<AddressBookState> emit,
  ) async {
    emit(const AddressBookState.loading());

    final searchQuery = event.query.trim().isEmpty ? null : event.query.trim();

    final result = await _getAddressBookUsecase(
      organizationCode: null,
      departmentCode: null,
      search: searchQuery,
      page: 0,
      pageSize: _pageSize,
    );

    result.fold(
      (error) => emit(AddressBookState.error(error.toString())),
      (users) => emit(
        AddressBookState.loaded(
          users: users,
          currentPage: 0,
          hasMorePages: users.length >= _pageSize,
          isLoadingMore: false,
          searchQuery: searchQuery,
        ),
      ),
    );
  }
}
