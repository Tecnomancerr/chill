import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chill/models/user.dart';
import 'package:chill/repositories/searchRepository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;

  SearchBloc({required SearchRepository searchRepository})
      : assert(searchRepository != null),
        _searchRepository = searchRepository,
        super(InitialSearchState());

  @override
  Stream<SearchState> mapEventToState(
      SearchEvent event,
      ) async* {
    if (event is SelectUserEvent) {
      yield* _mapSelectToState(
        currentUserId: event.currentUserId,
        selectedUserId: event.selectedUserId,
        name: event.name,
        photoUrl: event.photoUrl,
      );
    }
    if (event is PassUserEvent) {
      yield* _mapPassToState(
        currentUserId: event.currentUserId,
        selectedUserId: event.selectedUserId,
      );
    }
    if (event is LoadUserEvent) {
      yield* _mapLoadUserToState(currentUserId: event.userId);
    }
  }

  Stream<SearchState> _mapSelectToState({
    required String currentUserId,
    required String selectedUserId,
    required String name,
    required String photoUrl,
  }) async* {
    yield LoadingState();

    User user = await _searchRepository.chooseUser(
      currentUserId,
      selectedUserId,
      name,
      photoUrl,
    );

    User currentUser = await _searchRepository.getUserInterests(currentUserId);
    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapPassToState({
    required String currentUserId,
    required String selectedUserId,
  }) async* {
    yield LoadingState();
    User user = await _searchRepository.passUser(
      currentUserId,
      selectedUserId,
    );
    User currentUser = await _searchRepository.getUserInterests(currentUserId);

    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapLoadUserToState({required String currentUserId}) async* {
    yield LoadingState();
    User user = await _searchRepository.getUser(currentUserId);
    User currentUser = await _searchRepository.getUserInterests(currentUserId);

    yield LoadUserState(user, currentUser);
  }
}
