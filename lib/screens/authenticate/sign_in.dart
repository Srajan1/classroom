import 'package:classroom/screens/authenticate/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:classroom/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/error.dart';
import '../../constants/constants.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/signin';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final email = TextEditingController();
  bool _loading = false;
  final pass = TextEditingController();
  final AuthService _auth = AuthService();
  String err = '';
  GlobalKey _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return _loading
        ? Scaffold(
            body: Center(child: Text('Loading...')),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                MediaQuery.of(context).size.width * 0.1),
                            topRight: Radius.circular(
                                MediaQuery.of(context).size.width * 0.1))),
                    height: (size * 8) / 12,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size / 24,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Text('Login to continue',
                                    style: GoogleFonts.questrial(
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.w900,
                                      color: Theme.of(context).accentColor,
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
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor,
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
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor,
                                            width: 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      child: FlatButton(
                                        child: Text(
                                          'Forgot password',
                                          style: kSubtitleStyle,
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            _loading = true;
                                          });
                                          var value = new ErrorMsg(' ');
                                          print(value.error);
                                          await _auth.resetPassword(
                                              email.text, value);
                                          setState(() {
                                            _loading = false;
                                            err = value.error.toString();
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(err),
                                  ),
                                ),
                                SizedBox(
                                  height: size / 12,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Theme.of(context).accentColor,
                                    color: Theme.of(context).accentColor,
                                    child: FlatButton(
                                      onPressed: () async {
                                        {
                                          setState(() {
                                            _loading = true;
                                          });
                                          var value = new ErrorMsg(' ');
                                          print(value.error);
                                          await _auth.signIn(
                                              email.text, pass.text, value);
                                          setState(() {
                                            _loading = false;
                                            err = value.error.toString();
                                          });
                                          // print('$err err msg');
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          'LOGIN',
                                          style: kTitleStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).accentColor,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: FlatButton(
                                    onPressed: () async {
                                      setState(() {
                                        _loading = true;
                                      });
                                      var value = new ErrorMsg(' ');
                                      await _auth.signInWithGoogle(value);
                                      setState(() {
                                        _loading = false;
                                        err = value.error.toString();
                                        print(err);
                                      });
                                    },
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image(
                                              height: 20,
                                              image: AssetImage(
                                                  'assets/images/google_logo.png')),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Continue with google',
                                            style: kSubtitleStyle,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).accentColor,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        SignUp.routeName,
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        'Create new account',
                                        style: kSubtitleStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
