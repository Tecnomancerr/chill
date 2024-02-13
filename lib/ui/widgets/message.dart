import 'package:chill/models/message.dart';
import 'package:chill/repositories/messaging.dart';
import 'package:chill/ui/constants.dart';
import 'package:chill/ui/widgets/photo.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageWidget extends StatefulWidget {
  final String messageId, currentUserId;

  const MessageWidget({required this.messageId, required this.currentUserId});

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  MessagingRepository _messagingRepository = MessagingRepository();

  Message? _message; // Declare _message as nullable

  Future<void> getDetails() async {
    _message = await _messagingRepository.getMessageDetail(
        messageId: widget.messageId);

    // Update the state when _message is available
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _message == null // Check if _message is null
        ? Container() // Return an empty container if _message is null
        : Column(
      crossAxisAlignment: _message!.senderId == widget.currentUserId
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        // Rest of your widget code...
      ],
    );
  }
}
