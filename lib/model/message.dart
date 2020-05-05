import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;

  Message(
      {this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.timestamp});
  Message.imageMessage(
      {this.photoUrl,
      this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.timestamp});

  Map toMap() {
    Map<String, dynamic> myMap = Map<String, dynamic>();
    myMap['senderId'] = this.senderId;
    myMap['receiverId'] = this.receiverId;
    myMap['message'] = this.message;
    myMap['type'] = this.type;
    myMap['timestamp'] = this.timestamp;
    return myMap;
  }

  Map toImageMap() {
    Map<String, dynamic> myMap = Map<String, dynamic>();
    myMap['senderId'] = this.senderId;
    myMap['receiverId'] = this.receiverId;
    myMap['message'] = this.message;
    myMap['type'] = this.type;
    myMap['timestamp'] = this.timestamp;
    myMap['photoUrl'] = this.photoUrl;
    return myMap;
  }

  Message fromMap(Map<String, dynamic> myMap) {
    Message _message = Message(
        senderId: myMap['senderId'],
        receiverId: myMap['receiverId'],
        type: myMap['type'],
        message: myMap['message'],
        timestamp: myMap['timestamp']);
    return _message;
  }
}
