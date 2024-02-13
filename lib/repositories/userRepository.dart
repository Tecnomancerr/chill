import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  UserRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore
  })
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> signInWithEmail(String email, String password) async {

    await
    _firebaseAuth.signInWithEmailAndPassword(email: email,
        password: password);
  }


  Future<bool> isFirstTime(String userId) async {
    bool? exist; // Use a nullable type
    await FirebaseFirestore.instance.collection('users').doc(userId).get().then((user) {
      exist = user.exists;
    });

    return exist ?? false; // Return a default value if exist is null
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    print(_firebaseAuth);
    return await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser !=null;
  }



  Future<String> getUserId() async {
    return (await _firebaseAuth.currentUser)?.uid ?? 'N/A';
  }


  Future<void> profileSetup(
      File photo,
      String userId,
      String name,
      String gender,
      String interestedIn,
      DateTime age,
      GeoPoint location) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('userPhotos')
          .child(userId)
          .child(userId);
      final uploadTask = ref.putFile(photo);

      await uploadTask.whenComplete(() async {
        final url = await ref.getDownloadURL();
        await _firestore.collection('users').doc(userId).set({
          'uid': userId,
          'photoUrl': url,
          'name': name,
          'location': location,
          'gender': gender,
          'interestedIn': interestedIn,
          'age': age
        });
      });
    } catch (e) {
      // Handle file upload or Firestore data update errors here
      throw e;
    }
  }
}
