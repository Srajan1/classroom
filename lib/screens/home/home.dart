import 'package:flutter/material.dart';
import '../../services/auth.dart';

class Home extends StatelessWidget {
  final _auth = AuthService();
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
        actions: [
          FlatButton(
            onPressed: () async {
              await _auth.signOut();
            },
            child: Text('sign out'),
          )
        ],
      ),
    );
  }
}
