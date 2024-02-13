import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String name, photoUrl, lastMessagePhoto, lastMessage;
  final Timestamp timestamp;

  Chat({
    required this.name,
    required this.photoUrl,
    required this.lastMessagePhoto,
    required this.lastMessage,
    required this.timestamp,
  });
}
