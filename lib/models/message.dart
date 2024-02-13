import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderName;
  String senderId;
  String selectedUserId;
  String text;
  String photoUrl;
  File? photo;
  Timestamp? timestamp;

  Message({
    required this.senderName,
    required this.senderId,
    required this.selectedUserId,
    required this.text,
    required this.photoUrl,
    this.photo,
    this.timestamp,
  });
}
