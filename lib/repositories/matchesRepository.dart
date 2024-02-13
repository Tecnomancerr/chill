import 'package:chill/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesRepository {
  final FirebaseFirestore _firestore;

  MatchesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMatchedList(userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('matchedList')
        .snapshots();
  }

  Stream<QuerySnapshot> getSelectedList(userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('selectedList')
        .snapshots();
  }

  Future<User> getUserDetails(userId) async {
    User _user = User(
        'uid', 'name', 'gender', 'interestedIn', 'photo', Timestamp.now(), GeoPoint(0, 0),
        userId: userId

    ); // Provide the userId when creating the User object

    final userSnapshot =
    await _firestore.collection('users').doc(userId).get();
    final userData = userSnapshot.data();

    if (userData != null) {
      _user.uid = userId;
      _user.name = userData['name'] ?? '';
      _user.photo = userData['photoUrl'] ?? '';
      _user.age = userData['age'] ?? 0;
      _user.location = userData['location'] ?? '';
      _user.gender = userData['gender'] ?? '';
      _user.interestedIn = userData['interestedIn'] ?? '';
    }

    return _user;
  }

  Future<void> openChat({currentUserId, selectedUserId}) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .set({'timestamp': DateTime.now()});

    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('chats')
        .doc(currentUserId)
        .set({'timestamp': DateTime.now()});

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('matchedList')
        .doc(selectedUserId)
        .delete();

    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('matchedList')
        .doc(currentUserId)
        .delete();
  }

  Future<void> deleteUser(currentUserId, selectedUserId) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('selectedList')
        .doc(selectedUserId)
        .delete();
  }

  Future<void> selectUser(currentUserId, selectedUserId, currentUserName,
      currentUserPhotoUrl, selectedUserName, selectedUserPhotoUrl) async {
    await deleteUser(currentUserId, selectedUserId);

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('matchedList')
        .doc(selectedUserId)
        .set({
      'name': selectedUserName,
      'photoUrl': selectedUserPhotoUrl,
    });

    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('matchedList')
        .doc(currentUserId)
        .set({
      'name': currentUserName,
      'photoUrl': currentUserPhotoUrl,
    });
  }
}
