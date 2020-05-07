import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/model/message.dart';
import 'package:skypeclone/model/user.dart';
import 'package:skypeclone/model/vew_state.dart';
import 'package:skypeclone/provider/image_upload_provider.dart';
import 'package:skypeclone/resources/firebase_repo.dart';
import 'package:skypeclone/utils/Utils.dart';
import 'package:skypeclone/utils/cache-image.dart';
import 'package:skypeclone/utils/call_utilities.dart';
import 'package:skypeclone/utils/permissions.dart';
import 'package:skypeclone/utils/universal_variables.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;
  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  bool isWriting = false;
  User sender;
  String _currentUserId;
  ScrollController _listScrollController = ScrollController();
  bool showEmojiPicker = false;
  FocusNode textFieldFocusNode = FocusNode();
  FirebaseRepo _repo = FirebaseRepo();
  ImageUploadProvider _imageUploadProvider;

  setWritingTo(bool val) {
    setState(() {
      isWriting = val;
    });
  }

  pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _repo.uploadImage(
        image: selectedImage,
        receiverId: widget.receiver.uid,
        senderId: _currentUserId,
        imageUploadProvider: _imageUploadProvider);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repo.getCurrentUser().then((onValue) {
      _currentUserId = onValue.uid;
      setState(() {
        sender = User(
            uid: onValue.uid,
            name: onValue.displayName,
            email: onValue.email,
            profilephoto: onValue.photoUrl);
      });
    });
  }

  sendMessage() {
    var text = textFieldController.text;
    Message _message = Message(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );
    setState(() {
      isWriting = false;
    });

    _repo.addMessageToDB(_message, sender, widget.receiver);
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(
        title: Text(widget.receiver.name),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.video_call,
            ),
            onPressed: () async =>
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dial(
                        from: sender, to: widget.receiver, context: context)
                    : {},
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  margin: EdgeInsets.only(right: 25),
                  alignment: Alignment.centerRight,
                  child: CircularProgressIndicator(),
                )
              : Container(),
          chatControl(),
          showEmojiPicker
              ? Container(
                  child: emojiContainer(),
                )
              : Container(),
        ],
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      recommendKeywords: ["happy", "party", "food", "faces", "car"],
      numRecommended: 50,
      buttonMode: ButtonMode.CUPERTINO,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        textFieldController.text += emoji.emoji;
      },
    );
  }

  showKeyboard() => textFieldFocusNode.requestFocus();
  hideKeyboard() => textFieldFocusNode.unfocus();
  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
    showKeyboard();
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
    hideKeyboard();
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("messages")
          .document(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
        if (snapshots.data == null)
          return Center(child: CircularProgressIndicator());

        SchedulerBinding.instance.addPostFrameCallback((_) {
          _listScrollController.animateTo(
              _listScrollController.position.minScrollExtent,
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOutCirc);
        });
        return ListView.builder(
          padding: EdgeInsets.all(10),
          controller: _listScrollController,
          itemCount: snapshots.data.documents.length,
          reverse: true,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshots.data.documents[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
          child: Align(
        alignment: snapshot["senderId"] == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot["senderId"] == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      )),
    );
  }

  Widget senderLayout(Message snapshot) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        maxWidth: (MediaQuery.of(context).size.width * 0.65),
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding:
            snapshot.type == 'image' ? EdgeInsets.all(0) : EdgeInsets.all(10),
        child: getMessage(snapshot),
      ),
    );
  }

  getMessage(Message snapshot) {
    return snapshot.type != 'image'
        ? Text(
            snapshot.message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        : CachedImage(
            snapshot.photoUrl,
            height: 250,
            width: 250,
            radius: 10,
          );
  }

  Widget receiverLayout(Message snapshot) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
          padding:
              snapshot.type == 'image' ? EdgeInsets.all(0) : EdgeInsets.all(10),
          child: getMessage(snapshot)),
    );
  }

  Widget chatControl() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: UniversalVariables.fabGradient,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: () {
                addMediaModal(context);
              },
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Stack(
              children: <Widget>[
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocusNode,
                  onTap: () {
                    hideEmojiContainer();
                  },
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (val) {
                    val.length > 0 && val.trim() != ""
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.face),
                    splashColor: Colors.transparent,
                    onPressed: () {
                      if (!showEmojiPicker) {
                        showEmojiContainer();
                      } else {
                        hideEmojiContainer();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.mic,
                  ),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () => pickImage(source: ImageSource.camera),
                  child: Icon(Icons.camera_alt)),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    gradient: UniversalVariables.fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage();
                      setState(() {
                        textFieldController.clear();
                      });
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  addMediaModal(context) {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        backgroundColor: UniversalVariables.blackColor,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and Tools",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text("Media"),
                      leading: Icon(Icons.photo_size_select_actual),
                      subtitle: Text("Share Photos and Media"),
                      onTap: () {
                        pickImage(source: ImageSource.gallery);
                      },
                    ),
                    ListTile(
                      title: Text("File"),
                      leading: Icon(Icons.insert_drive_file),
                      subtitle: Text("Share Files"),
                    ),
                    ListTile(
                      title: Text("Contact"),
                      leading: Icon(Icons.contacts),
                      subtitle: Text("Share contacts"),
                    ),
                    ListTile(
                      title: Text("Location"),
                      leading: Icon(Icons.add_location),
                      subtitle: Text("Share a location"),
                    ),
                    ListTile(
                      title: Text("Schedule Call"),
                      leading: Icon(Icons.access_time),
                      subtitle: Text("Arrange a call and get reminders"),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
