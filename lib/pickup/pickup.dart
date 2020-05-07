import 'package:flutter/material.dart';
import 'package:skypeclone/Screens/call_screens/call_screen.dart';
import 'package:skypeclone/model/call.dart';
import 'package:skypeclone/resources/call_methods.dart';
import 'package:skypeclone/utils/permissions.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();
  PickupScreen({@required this.call});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: <Widget>[
              Text(
                "Incoming.. ",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 50,
              ),
              Image.network(
                call.callerPic,
                height: 50,
                width: 150,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                call.callerName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 75,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.call_end),
                    color: Colors.red,
                    onPressed: () async {
                      await callMethods.endCall(call: call);
                    },
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async => await Permissions
                            .cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallScreen(call: call),
                            ),
                          )
                        : {},
                  ),
                ],
              )
            ],
          )),
    );
  }
}
