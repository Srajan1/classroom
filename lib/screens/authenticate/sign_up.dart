import 'dart:io';

import 'package:classroom/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:classroom/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/error.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final email = TextEditingController();
  final name = TextEditingController();
  final pass = TextEditingController();
  final passConfirm = TextEditingController();
  final AuthService _auth = AuthService();
  GlobalKey _formKey = GlobalKey<FormState>();
  String err = '';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return loading
        ? Scaffold(
            body: Center(child: Text('Loading...')),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: (size * 4) / 12,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(
                              'Manage your classes',
                              textAlign: TextAlign.center,
                              style: kPageTitleStyle,
                            ),
                          ),
                          SizedBox(
                            height: size / 24,
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                'Manage your assignments and test through this app, whether you are a teacher or student. 😊😊',
                                textAlign: TextAlign.center,
                                style: kTitleStyle,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      MediaQuery.of(context).size.width * 0.1),
                                  topRight: Radius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.1))),
                          height: (size * 8) / 12,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size / 24,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Text('Register to continue',
                                          style: GoogleFonts.questrial(
                                            fontSize: 23.0,
                                            fontWeight: FontWeight.w900,
                                            color:
                                                Theme.of(context).accentColor,
                                            wordSpacing: 2.5,
                                          )),
                                      SizedBox(
                                        height: size / 24,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: email,
                                          decoration: InputDecoration(
                                            hintText: 'Email',
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  width: 1.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: name,
                                          decoration: InputDecoration(
                                            hintText: 'Name',
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  width: 1.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: pass,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            hintText: 'Password',
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  width: 1.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Text(err),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size / 24,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          shadowColor:
                                              Theme.of(context).accentColor,
                                          color: Theme.of(context).accentColor,
                                          child: FlatButton(
                                            onPressed: () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              var value = new ErrorMsg(' ');
                                              await _auth.signUp(email.text,
                                                  pass.text, value, name.text);
                                              setState(() {
                                                loading = false;
                                                err = value.error.toString();
                                              });
                                              print(value);
                                            },
                                            child: Center(
                                              child: Text(
                                                'Register',
                                                style: kTitleStyle,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Center(
                                            child: Text(
                                              'Go back to login',
                                              style: kSubtitleStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ]),
            ));
  }
}
