import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skypeclone/pageviews/chat_list_screen.dart';
import 'package:skypeclone/resources/firebase_repo.dart';
import 'package:skypeclone/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  FirebaseUser user;
  HomeScreen(this.user);
  @override
  _HomeScreenState createState() => _HomeScreenState(user);
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseRepo _repo = FirebaseRepo();
  FirebaseUser user;
  PageController pageController;
  int _page = 0;
  _HomeScreenState(this.user);
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            ChatListScreen(),
            Center(
              child: Text("Call List"),
            ),
            Center(
              child: Text("Contacts Screen"),
            ),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: AlwaysScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat,
                        color: _page == 0
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor),
                    title: Text(
                      "Chats",
                      style: TextStyle(
                          fontSize: 10,
                          color: _page == 0
                              ? UniversalVariables.lightBlueColor
                              : UniversalVariables.greyColor),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.call,
                        color: _page == 1
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor),
                    title: Text(
                      "Calls",
                      style: TextStyle(
                          fontSize: 10,
                          color: _page == 1
                              ? UniversalVariables.lightBlueColor
                              : UniversalVariables.greyColor),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.contact_mail,
                        color: _page == 2
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor),
                    title: Text(
                      "Contacts",
                      style: TextStyle(
                          fontSize: 10,
                          color: _page == 2
                              ? UniversalVariables.lightBlueColor
                              : UniversalVariables.greyColor),
                    )),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
