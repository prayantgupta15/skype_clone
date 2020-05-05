import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skypeclone/model/message.dart';
import 'package:skypeclone/model/user.dart';
import 'package:skypeclone/utils/Utils.dart';

class FirebaseMethods {
  User user_class = User();

  GoogleSignIn _googleSignIn = GoogleSignIn();

  static final Firestore firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  StorageReference _storageReference;

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    print("Print CurrentUser:" + currentUser.toString());
    return (currentUser);
  }

  Future<FirebaseUser> signIn() async {
    print("Print signIN");
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    print("Print signinaccount");
    print(_signInAccount.toString()); //SHOWS THE GOOGLE SIGNIN BLOCK
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;
    print("Print CREd" + _signInAuthentication.toString());
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);
    print("print tokens:" + credential.toString());
    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("print loggedinUser" + user.toString());
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;
    return docs.length == 0 ? true : false;
  }

  Future<FirebaseUser> addDataToDB(FirebaseUser currentuser) async {
    Utils utils = Utils();
    String un = utils.getUsername(currentuser.email);
    user_class = User(
      uid: currentuser.uid,
      name: currentuser.displayName,
      email: currentuser.email,
      username: un,
      profilephoto: currentuser.photoUrl,
    );

    Firestore.instance
        .collection("users")
        .document(currentuser.uid)
        .setData(user_class.toMap(user_class));
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot =
        await firestore.collection("users").getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid)
        userList.add(User.fromMap(querySnapshot.documents[i].data));
    }
    return userList;
  }

  Future<void> addMessageToDB(
      Message _message, User sender, User receiver) async {
    await firestore
        .collection("messages")
//        .document(sender.uid).collection(receiver.uid)
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(_message.toMap());

    await firestore
        .collection("messages")
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(_message.toMap());
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask _storageUploadtask = _storageReference.putFile(image);
      var url =
          await ((await _storageUploadtask.onComplete).ref.getDownloadURL());
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setImagemsg(String url, String reciverId, String senderId) async {
    Message _message;
    _message = Message.imageMessage(
        message: "IMAGE",
        senderId: senderId,
        receiverId: reciverId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');
    var map = _message.toImageMap();

    //SET IMAGE MESSAGE TO DB

    await firestore
        .collection("messages")
//        .document(sender.uid).collection(receiver.uid)
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await firestore
        .collection("messages")
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  void uploadImage(File image, String reciverId, String senderId) async {
    String url = await uploadImageToStorage(image);
    setImagemsg(url, reciverId, senderId);
  }
}
