class Call {
  String callerId;
  String callerName;
  String callerPic;
  String receiverId;
  String receiverName;
  String receiverPic;
  String channelId;
  bool hasDialled;

  Call(
      {this.callerId,
      this.callerName,
      this.callerPic,
      this.receiverId,
      this.receiverName,
      this.receiverPic,
      this.channelId,
      this.hasDialled});

  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> myMap = Map();
    myMap['callerId'] = this.callerId;
    myMap['callerName'] = this.callerName;
    myMap['callerPic'] = this.callerPic;
    myMap['receiverId'] = this.receiverId;
    myMap['receiverName'] = this.receiverName;
    myMap['receiverPic'] = this.receiverPic;
    myMap['channelId'] = this.channelId;
    myMap['hasDialled'] = this.hasDialled;
    return myMap;
  }

  Call.fromMap(Map myMap) {
    this.callerId = myMap['callerId'];
    this.callerName = myMap['callerName'];
    this.callerPic = myMap['callerPic'];
    this.receiverId = myMap['receiverId'];
    this.receiverName = myMap['receiverName'];
    this.receiverPic = myMap['receiverPic'];
    this.channelId = myMap['channelId'];
    this.hasDialled = myMap['hasDialled'];
  }
}
