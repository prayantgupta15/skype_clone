import 'package:flutter/cupertino.dart';
import 'package:skypeclone/model/user.dart';
import 'package:skypeclone/resources/firebase_repo.dart';

class UserProvider with ChangeNotifier {
  User _user;
  FirebaseRepo _repo = FirebaseRepo();

  User get getUser => _user;

  void refreshUser() async {
    User user = await _repo.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
