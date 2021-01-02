import 'package:classroom/screens/views/home.dart';
import 'package:classroom/services/auth.dart';
import 'package:flutter/material.dart';

class LogOut extends StatelessWidget {
  final _auth = AuthService();
  static const routeName = '/logout';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Are you sure you wanna logout?'),
          RaisedButton(
            child: Text('Yes'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
          RaisedButton(
            child: Text('Get back to classes'),
            onPressed: () async {
              Navigator.popAndPushNamed(context, Home.routeName);
            },
          )
        ],
      ),
    );
  }
}
