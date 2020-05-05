import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/Screens/search_screen.dart';
import 'package:skypeclone/resources/firebase_repo.dart';
import 'package:skypeclone/utils/universal_variables.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  FirebaseRepo _repo = FirebaseRepo();
  String currentUserId;
  List<String> initials;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repo.getCurrentUser().then((user) {
      setState(() {
        currentUserId = user.uid;
        initials = user.displayName.split(" ");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 8,
        backgroundColor: UniversalVariables.blackColor,
        leading: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
        title: UserCircle(initials),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchScreen();
              }));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: chat_list(),
    );
  }
}

class UserCircle extends StatelessWidget {
  final List<String> text;
  UserCircle(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: UniversalVariables.separatorColor),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: text == null
                ? Text("S")
                : Text(
                    text[0][0] + text[1][0],
                    style: TextStyle(
                      color: UniversalVariables.lightBlueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: UniversalVariables.onlineDotColor),
            ),
          )
        ],
      ),
    );
  }
}

class chat_list extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Stack(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                leading: Container(
                  constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage('assets/dp.JPG'),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          constraints:
                              BoxConstraints(maxHeight: 8, maxWidth: 8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: UniversalVariables.onlineDotColor),
                        ),
                      )
                    ],
                  ),
                ),
                title: Text("Prayant Gupta"),
                subtitle: Text("Hello"),
              ),
            ],
          );
        });
  }
}
