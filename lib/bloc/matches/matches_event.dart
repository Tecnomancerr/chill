import 'package:equatable/equatable.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object?> get props => [];
}

class LoadListsEvent extends MatchesEvent {
  final String userId;

  LoadListsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AcceptUserEvent extends MatchesEvent {
  final String currentUser,
      selectedUser,
      selectedUserName,
      selectedUserPhotoUrl,
      currentUserName,
      currentUserPhotoUrl;

  AcceptUserEvent({
    required this.currentUser,
    required this.selectedUser,
    required this.selectedUserName,
    required this.selectedUserPhotoUrl,
    required this.currentUserName,
    required this.currentUserPhotoUrl,
  });

  @override
  List<Object?> get props => [
    currentUser,
    selectedUser,
    selectedUserName,
    selectedUserPhotoUrl,
    currentUserName,
    currentUserPhotoUrl,
  ];
}

class DeleteUserEvent extends MatchesEvent {
  final String currentUser, selectedUser;

  DeleteUserEvent({
    required this.currentUser,
    required this.selectedUser,
  });

  @override
  List<Object?> get props => [
    currentUser,
    selectedUser,
  ];
}

class OpenChatEvent extends MatchesEvent {
  final String currentUser, selectedUser;

  OpenChatEvent({
    required this.currentUser,
    required this.selectedUser,
  });

  @override
  List<Object?> get props => [
    currentUser,
    selectedUser,
  ];
}
