import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUserEvent extends SearchEvent {
  final String userId;

  LoadUserEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SelectUserEvent extends SearchEvent {
  final String currentUserId;
  final String name;
  final String photoUrl;
  final String selectedUserId;

  SelectUserEvent({
    required this.currentUserId,
    required this.name,
    required this.photoUrl,
    required this.selectedUserId,
  });

  @override
  List<Object> get props => [currentUserId, selectedUserId, name, photoUrl];
}

class PassUserEvent extends SearchEvent {
  final String currentUserId;
  final String selectedUserId;

  PassUserEvent(String userId, String uid, {
    required this.currentUserId,
    required this.selectedUserId,
  });

  @override
  List<Object> get props => [currentUserId, selectedUserId];
}
