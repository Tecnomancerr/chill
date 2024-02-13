import 'package:chill/models/message.dart';
import 'package:chill/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final FirebaseFirestore _firestore;

  MessageRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChats({String? userId}) {
    return _firestore
        .collection('users')
        .doc(userId) // Use .doc(userId) to access a document
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteChat({String? currentUserId, String? selectedUserId}) async {
    await _firestore
        .collection('users')
        .doc(currentUserId) // Use .doc(currentUserId) to access a document
        .collection('chats')
        .doc(selectedUserId) // Use .doc(selectedUserId) to access a document
        .delete();
  }

  Future<User> getUserDetail({String? userId}) async {
    User _user = User(
        'uid', 'name', 'gender', 'interestedIn', 'photo', Timestamp.now(), GeoPoint(0, 0), userId: 'uid',



    );

    final userSnapshot =
    await _firestore.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      _user.uid = userId!;
      _user.name = userData['name'];
      _user.photo = userData['photoUrl'];
      _user.age = userData['age'];
      _user.location = userData['location'];
      _user.gender = userData['gender'];
      _user.interestedIn = userData['interestedIn'];
    }

    return _user;
  }

  Future<Message> getLastMessage({String? currentUserId, String? selectedUserId}) async {
    Message _message = Message(senderName: '', senderId: '', selectedUserId: '', text: '', photoUrl: '');

    final messageQuerySnapshot = await _firestore
        .collection('users')
        .doc(currentUserId) // Use .doc(currentUserId) to access a document
        .collection('chats')
        .doc(selectedUserId) // Use .doc(selectedUserId) to access a document
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1) // Limit to one document
        .get();

    if (messageQuerySnapshot.docs.isNotEmpty) {
      final messageDocument = messageQuerySnapshot.docs.first;
      final messageData = messageDocument.data() as Map<String, dynamic>;

      _message.text = messageData['text'];
      _message.photoUrl = messageData['photoUrl'];
      _message.timestamp = messageData['timestamp'];
    }

    return _message;
  }
}
