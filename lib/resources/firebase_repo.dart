import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:skypeclone/model/message.dart';
import 'package:skypeclone/model/user.dart';
import 'package:skypeclone/resources/firebase_methods.dart';

class FirebaseRepo {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseMethods.authenticateUser(user);

  Future<FirebaseUser> addDataToDB(FirebaseUser user) =>
      _firebaseMethods.addDataToDB(user);

  Future<void> signOut() => _firebaseMethods.signOut();

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) =>
      _firebaseMethods.fetchAllUsers(currentUser);

  Future<void> addMessageToDB(Message _message, User sender, User receiver) =>
      _firebaseMethods.addMessageToDB(_message, sender, receiver);

  void uploadImage(
          {@required File image,
          @required String receiverId,
          @required String senderId}) =>
      _firebaseMethods.uploadImage(image, receiverId, senderId);
}
