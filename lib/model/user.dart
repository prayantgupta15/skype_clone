class User {
  String uid, name, email, username, status, profilephoto;
  int state;

  User(
      {this.uid,
      this.name,
      this.email,
      this.username,
      this.status,
      this.profilephoto});

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data['status'] = user.status;
    data['profilephoto'] = user.profilephoto;
    return data;
  }

  User.fromMap(Map<String, dynamic> myMap) {
    this.uid = myMap['uid'];
    this.name = myMap['name'];
    this.email = myMap['email'];
    this.username = myMap['username'];
    this.status = myMap['status'];
    this.profilephoto = myMap['profilephoto'];
  }
}
