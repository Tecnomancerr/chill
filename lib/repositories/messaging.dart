import 'package:chill/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io'; // Import the File class.

class MessagingRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  String uuid = Uuid().v4();

  MessagingRepository({FirebaseStorage? firebaseStorage, FirebaseFirestore? firestore})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> sendMessage({required Message message, File? photo}) async {
    UploadTask? storageUploadTask;
    DocumentReference messageRef = _firestore.collection('messages').doc();
    CollectionReference senderRef = _firestore
        .collection('users')
        .doc(message.senderId)
        .collection('chats')
        .doc(message.selectedUserId)
        .collection('messages');

    CollectionReference sendUserRef = _firestore
        .collection('users')
        .doc(message.selectedUserId)
        .collection('chats')
        .doc(message.senderId)
        .collection('messages');

    if (photo != null) {
      Reference photoRef = _firebaseStorage
          .ref()
          .child('messages')
          .child(messageRef.id)
          .child(uuid);

      storageUploadTask = photoRef.putFile(photo);

      await storageUploadTask.then((TaskSnapshot photo) async {
        final photoUrl = await photo.ref.getDownloadURL();
        await messageRef.set({
          'senderName': message.senderName,
          'senderId': message.senderId,
          'text': null,
          'photoUrl': photoUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
      });

      senderRef
          .doc(messageRef.id)
          .set({'timestamp': FieldValue.serverTimestamp()});

      sendUserRef
          .doc(messageRef.id)
          .set({'timestamp': FieldValue.serverTimestamp()});

      await _firestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': FieldValue.serverTimestamp()});

      await _firestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': FieldValue.serverTimestamp()});
    }
    if (message.text != null) {
      await messageRef.set({
        'senderName': message.senderName,
        'senderId': message.senderId,
        'text': message.text,
        'photoUrl': null,
        'timestamp': FieldValue.serverTimestamp(),
      });

      senderRef
          .doc(messageRef.id)
          .set({'timestamp': FieldValue.serverTimestamp()});

      sendUserRef
          .doc(messageRef.id)
          .set({'timestamp': FieldValue.serverTimestamp()});

      await _firestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': FieldValue.serverTimestamp()});

      await _firestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': FieldValue.serverTimestamp()});
    }
  }

  Stream<QuerySnapshot> getMessages({required String currentUserId, required String selectedUserId}) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Message> getMessageDetail({required String messageId}) async {
    Message _message = Message(senderName: '', senderId: '', selectedUserId: '', text: '', photoUrl: '');

    await _firestore
        .collection('messages')
        .doc(messageId)
        .get()
        .then((DocumentSnapshot message) {
      _message.senderId = message['senderId'];
      _message.senderName = message['senderName'];
      _message.timestamp = message['timestamp'];
      _message.text = message['text'];
      _message.photoUrl = message['photoUrl'];
    });

    return _message;
  }
}
