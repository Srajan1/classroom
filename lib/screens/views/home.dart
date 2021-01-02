import 'package:classroom/screens/authenticate/logout.dart';
import 'package:classroom/services/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';

class Home extends StatelessWidget {
  final _auth = AuthService();
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final name = user != null ? user.displayName : 'Name';
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        // actions: [
        //   RaisedButton(
        //     onPressed: () async {
        //       // Navigator.popAndPushNamed(context, LogOut.routeName);

        //       // print('Logged out');
        //     },
        //     child: Text('Logout'),
        //   )
        // ],
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Colors.white,
        title: Text(
          name,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
