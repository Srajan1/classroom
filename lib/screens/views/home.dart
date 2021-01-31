import 'package:classroom/constants/constants.dart';
import 'package:classroom/screens/authenticate/logout.dart';
import 'package:classroom/screens/views/create_class.dart';
import 'package:classroom/screens/views/created_classes.dart';
import 'package:classroom/screens/views/enrolled_classes.dart';
import 'package:classroom/screens/views/join_class.dart';
import 'package:classroom/services/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = AuthService();
  int _index = 0;
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
    ;
    var height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final name = user != null ? user.displayName : 'Name';
    return Scaffold(
      // drawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              _auth.signOut();

              print('Logged out');
            },
            icon: Icon(Icons.logout),
          )
        ],
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Colors.white,
        title: Text(
          name,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserInfo(imgURL: imgURL, user: user),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 20.0),
              child: Text(
                'Manage your classes like never before. 😁😁',
                textAlign: TextAlign.center,
                style: GoogleFonts.questrial(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(20, 33, 61, 1),
                  wordSpacing: 2.5,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 20.0),
              child: Text(
                'Either be a student or a teacher',
                textAlign: TextAlign.center,
                style: GoogleFonts.questrial(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(20, 33, 61, 1),
                  wordSpacing: 2.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Divider(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 20.0),
              child: Text(
                'Student\'s section',
                style: kPageTitleStyleBlack,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(JoinClass.routeName);
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 25.0, // soften the shadow
                            spreadRadius: 5.0, //extend the shadow
                            offset: Offset(
                              15.0, // Move to right 10  horizontally
                              15.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        color: Color.fromRGBO(60, 145, 230, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: MediaQuery.of(context).size.width * .4,
                    child: Text(
                      'Join a new class',
                      textAlign: TextAlign.center,
                      style: kPageTitleStyle,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(EnrolledClasses.routeName,
                        arguments: user.email);
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 25.0, // soften the shadow
                            spreadRadius: 5.0, //extend the shadow
                            offset: Offset(
                              15.0, // Move to right 10  horizontally
                              15.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        color: Color.fromRGBO(52, 46, 55, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: MediaQuery.of(context).size.width * .4,
                    child: Text(
                      'View classes',
                      textAlign: TextAlign.center,
                      style: kPageTitleStyle,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Teacher\'s section',
                style: kPageTitleStyleBlack,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, CreateClass.routeName);
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 25.0, // soften the shadow
                            spreadRadius: 5.0, //extend the shadow
                            offset: Offset(
                              15.0, // Move to right 10  horizontally
                              15.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        color: Color.fromRGBO(52, 46, 55, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: MediaQuery.of(context).size.width * .4,
                    child: Text(
                      'Create a new class',
                      textAlign: TextAlign.center,
                      style: kPageTitleStyle,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(CreatedClasses.routeName,
                        arguments: user.email);
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 25.0, // soften the shadow
                            spreadRadius: 5.0, //extend the shadow
                            offset: Offset(
                              15.0, // Move to right 10  horizontally
                              15.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        color: Color.fromRGBO(60, 145, 230, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: MediaQuery.of(context).size.width * .4,
                    child: Text(
                      'View classes',
                      textAlign: TextAlign.center,
                      style: kPageTitleStyle,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key key,
    @required this.imgURL,
    @required this.user,
  }) : super(key: key);

  final imgURL;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
          child: Text(
            'You are currently signed in as..',
            style: GoogleFonts.roboto(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
              child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill, image: new NetworkImage(imgURL)))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.displayName,
                      style:
                          GoogleFonts.questrial(fontWeight: FontWeight.bold)),
                  Text(user.email,
                      style:
                          GoogleFonts.questrial(fontWeight: FontWeight.w100)),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Divider(),
        ),
      ],
    );
  }
}
