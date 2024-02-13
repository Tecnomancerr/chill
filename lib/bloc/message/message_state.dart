import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  @override
  List<Object> get props => [];
}

class MessageInitialState extends MessageState {}

class ChatLoadingState extends MessageState {}

class ChatLoadedState extends MessageState {
  final Stream<QuerySnapshot> chatStream;

  ChatLoadedState({required this.chatStream});

  @override
  List<Object> get props => [chatStream];
}
