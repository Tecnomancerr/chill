import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object> get props => [];
}

class LoadingState extends MatchesState {}

class LoadUserState extends MatchesState {
  final Stream<QuerySnapshot<Object?>> matchedList;
  final Stream<QuerySnapshot<Object?>> selectedList;

  LoadUserState({this.matchedList = const Stream.empty(), this.selectedList = const Stream.empty()});

  @override
  List<Object> get props => [matchedList, selectedList];
}
