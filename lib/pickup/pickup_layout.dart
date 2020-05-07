import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/model/call.dart';
import 'package:skypeclone/pickup/pickup.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/resources/call_methods.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  PickupLayout({this.scaffold});
  CallMethods callMethods = CallMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return userProvider != null && userProvider.getUser != null
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data != null) {
                Call call = Call.fromMap(snapshot.data.data);
                if (!call.hasDialled)
                  return PickupScreen(call: call);
                else
                  return scaffold;
              }
              return (scaffold);
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
