import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/Screens/HomeScreen.dart';
import 'package:skypeclone/Screens/LoginScreen.dart';
import 'package:skypeclone/Screens/search_screen.dart';
import 'package:skypeclone/model/vew_state.dart';
import 'package:skypeclone/pageviews/chat_list_screen.dart';
import 'package:skypeclone/provider/image_upload_provider.dart';
import 'package:skypeclone/resources/firebase_repo.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepo _repo = FirebaseRepo();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageUploadProvider>(
      create: (context) => ImageUploadProvider(),
      child: MaterialApp(
        title: "Skype Clone",

//      initialRoute: '/',
//      routes: {
//        '/search_screen' : (context)=>SearchScreen()
//      },
//      home: ChatListScreen(),
        theme: ThemeData(brightness: Brightness.dark),
        home: FutureBuilder(
          future: _repo.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              FirebaseUser user = snapshot.data;
              return HomeScreen(user);
            } else {
              print(snapshot.toString());
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
