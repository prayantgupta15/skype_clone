import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skypeclone/Screens/call_screens/call_screen.dart';
import 'package:skypeclone/model/call.dart';
import 'package:skypeclone/model/user.dart';
import 'package:skypeclone/resources/call_methods.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, context}) async {
    print("2.entered CallUtils.dial");
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilephoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilephoto,
      channelId: Random().nextInt(10000).toString(),
    );
    print("3. making call");
    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialled = true;

    if (callMade) {
      print("5.Call made");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
