import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class ChatStreamEvent extends MessageEvent {
  final String currentUserId;

  ChatStreamEvent({required this.currentUserId}); // Mark as required

  @override
  List<Object> get props => [currentUserId];
}
