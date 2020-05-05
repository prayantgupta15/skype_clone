import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skypeclone/Screens/chatscreen.dart';
import 'package:skypeclone/model/user.dart';
import 'package:skypeclone/resources/firebase_repo.dart';
import 'package:skypeclone/utils/universal_variables.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepo _repo = FirebaseRepo();

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();
//  FirebaseUser user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repo.getCurrentUser().then((FirebaseUser currentUser) {
      _repo.fetchAllUsers(currentUser).then((List<User> list) {
        setState(() {
          userList = list;
          print("userlist:" + userList.length.toString());
          print("list:" + list.length.toString());
          print(list[0].username);
        });
      });
    });
  }

  buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList.where((User user) {
            String _getUN = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchUserName = _getName.contains(_query);
            bool matchName = _getUN.contains(_query);

            return (matchName || matchUserName);

////                  (user.username.toLowerCase().contains(query.toLowerCase()) ||
////                      (user.name.toLowerCase().contains(query.toLowerCase()))),
          }).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
          uid: suggestionList[index].uid,
          profilephoto: suggestionList[index].profilephoto,
          name: suggestionList[index].name,
          username: suggestionList[index].username,
        );
        return ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          receiver: searchedUser,
                        )));
          },
          title: Text(
            searchedUser.username,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(
              color: UniversalVariables.greyColor,
            ),
          ),
          leading: Container(
            constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 30,
                  minRadius: 30,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(searchedUser.profilephoto),
                ),
//                Align(
//                  alignment: Alignment.bottomRight,
//                  child: Container(
//                    constraints: BoxConstraints(maxHeight: 8, maxWidth: 8),
//                    decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        color: UniversalVariables.onlineDotColor),
//                  ),
//                )
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: GradientAppBar(
        elevation: 8,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              UniversalVariables.gradientColorStart,
              UniversalVariables.gradientColorEnd
            ]),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 10),
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  query = val;
                });
              },
              cursorColor: Colors.white,
              autofocus: true,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 35),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (callback) => searchController.clear());
                    },
                  ),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      color: Color(0x88ffffff))),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: buildSuggestions(query),
      ),
    );
  }
}
