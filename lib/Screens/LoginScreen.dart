import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skypeclone/Screens/HomeScreen.dart';
import 'package:skypeclone/resources/firebase_repo.dart';
import 'package:skypeclone/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepo _repo = FirebaseRepo();
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: Stack(
          children: <Widget>[
            Center(
              child: loginButton(),
            ),
            isPressed ? Center(child: CircularProgressIndicator()) : Container()
          ],
        ));
  }

  Widget loginButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: FlatButton(
        child: Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.red,
            fontSize: 25,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () => performLogin(),
      ),
    );
  }

  void performLogin() {
    setState(() {
      isPressed = true;
    });
    _repo.signIn().then((FirebaseUser user) {
      if (user != null) {
        print("authnticateUser function");
        authenticateUser(user);
      } else
        print("errror");
    });
  }

  void authenticateUser(FirebaseUser user) {
    _repo.authenticateUser(user).then((isNewUser) {
      setState(() {
        isPressed = false;
      });
      if (isNewUser) {
        print("print Adding NewUser  ");
        _repo.addDataToDB(user).then((user) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen(user);
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen(user);
        }));
      }
    });
  }
}
