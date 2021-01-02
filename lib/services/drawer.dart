import 'package:classroom/constants/constants.dart';
import 'package:classroom/screens/views/create_class.dart';
import 'package:classroom/screens/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class CustomDrawer extends StatelessWidget {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    var imgURL;
    if (user == null) {
      imgURL =
          'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    } else {
      imgURL = user.photoURL != null
          ? user.photoURL
          : 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    }
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(imgURL))))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      user != null ? user.displayName : 'user',
                      style: kPageTitleStyleBlack,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      user != null ? user.email : 'email',
                      style: kHintTextStyle,
                    ),
                  )
                ],
              ),
              Divider(),
              RaisedButton(
                splashColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.popAndPushNamed(context, Home.routeName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: [Icon(Icons.add_business), Text('Home')],
                    ),
                  ],
                ),
              ),
              RaisedButton(
                splashColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.popAndPushNamed(context, CreateClass.routeName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: [
                        Icon(Icons.add_business),
                        Text('Create new class')
                      ],
                    ),
                  ],
                ),
              ),
              RaisedButton(
                splashColor: Theme.of(context).primaryColor,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      children: [Icon(Icons.library_add), Text('Join a class')],
                    ),
                  ],
                ),
              ),
              RaisedButton(
                splashColor: Theme.of(context).primaryColor,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      children: [Icon(Icons.assignment), Text('Assignments')],
                    ),
                  ],
                ),
              ),
              RaisedButton(
                splashColor: Theme.of(context).primaryColor,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      children: [Icon(Icons.work), Text('All classes')],
                    ),
                  ],
                ),
              ),
              Divider(),
              RaisedButton(
                splashColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  await _auth.signOut();
                  Phoenix.rebirth(context);
                  print('Logged out');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      children: [Icon(Icons.logout), Text('Logout')],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
