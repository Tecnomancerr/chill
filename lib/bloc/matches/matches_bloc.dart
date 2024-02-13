import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chill/repositories/matchesRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final MatchesRepository _matchesRepository;

  MatchesBloc({required MatchesRepository matchesRepository})
      : assert(matchesRepository != null),
        _matchesRepository = matchesRepository,
        super(LoadingState());

  @override
  Stream<MatchesState> mapEventToState(MatchesEvent event) async* {
    if (event is LoadListsEvent) {
      yield* _mapLoadListToState(currentUserId: event.userId);
    }
    if (event is DeleteUserEvent) {
      yield* _mapDeleteUserToState(
          currentUserId: event.currentUser, selectedUserId: event.selectedUser);
    }
    if (event is OpenChatEvent) {
      yield* _mapOpenChatToState(
          currentUserId: event.currentUser, selectedUserId: event.selectedUser);
    }
    if (event is AcceptUserEvent) {
      yield* _mapAcceptUserToState(
        currentUserId: event.currentUser,
        selectedUserId: event.selectedUser,
        currentUserName: event.currentUserName,
        currentUserPhotoUrl: event.currentUserPhotoUrl,
        selectedUserName: event.selectedUserName,
        selectedUserPhotoUrl: event.selectedUserPhotoUrl,
      );
    }
  }

  Stream<MatchesState> _mapLoadListToState({required String currentUserId}) async* {
    yield LoadingState();

    Stream<QuerySnapshot> matchedList =
    _matchesRepository.getMatchedList(currentUserId);

    Stream<QuerySnapshot> selectedList =
    _matchesRepository.getSelectedList(currentUserId);

    yield LoadUserState(matchedList: matchedList, selectedList: selectedList);
  }

  Stream<MatchesState> _mapDeleteUserToState(
      {required String currentUserId, required String selectedUserId}) async* {
    _matchesRepository.deleteUser(currentUserId, selectedUserId);
  }

  Stream<MatchesState> _mapOpenChatToState(
      {required String currentUserId, required String selectedUserId}) async* {
    _matchesRepository.openChat(
        currentUserId: currentUserId, selectedUserId: selectedUserId);
  }

  Stream<MatchesState> _mapAcceptUserToState(
      {required String currentUserId,
        required String selectedUserId,
        required String currentUserName,
        required String currentUserPhotoUrl,
        required String selectedUserName,
        required String selectedUserPhotoUrl}) async* {
    await _matchesRepository.selectUser(
        currentUserId,
        selectedUserId,
        currentUserName,
        currentUserPhotoUrl,
        selectedUserName,
        selectedUserPhotoUrl);
  }
}
