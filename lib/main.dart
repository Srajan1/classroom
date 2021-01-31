import 'package:classroom/screens/authenticate/logout.dart';
import 'package:classroom/screens/authenticate/sign_in.dart';
import 'package:classroom/screens/authenticate/sign_up.dart';
import 'package:classroom/screens/views/class_announcements.dart';
import 'package:classroom/screens/views/create_class.dart';
import 'package:classroom/screens/views/enrolled_classes.dart';
import 'package:classroom/screens/views/home.dart';
import 'package:classroom/screens/views/join_class.dart';
import 'package:classroom/screens/views/subject_class.dart';
import 'package:classroom/screens/views/subject_class_student.dart';
import 'package:classroom/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import './screens/views/created_classes.dart';
import './wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIOverlays([]);

  await Firebase.initializeApp();
  runApp(Phoenix(child: MyApp()));
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor colorCustomAccent = MaterialColor(0xFF2a9d8f, color);
MaterialColor colorCustomSwatch = MaterialColor(0xFFe76f51, color);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'Montserrat',
              primarySwatch: colorCustomSwatch,
              accentColor: colorCustomAccent,
              textTheme: TextTheme(
                headline1:
                    TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              )),
          home: Wrapper(),
          routes: {
            SignUp.routeName: (_) => SignUp(),
            Home.routeName: (_) => Home(),
            SignIn.routeName: (_) => SignIn(),
            CreateClass.routeName: (_) => CreateClass(),
            LogOut.routeName: (_) => LogOut(),
            CreatedClasses.routeName: (_) => CreatedClasses(),
            JoinClass.routeName: (_) => JoinClass(),
            SubjectClass.routeName: (_) => SubjectClass(),
            EnrolledClasses.routeName: (_) => EnrolledClasses(),
            SubjectClassStudent.routeName: (_) => SubjectClassStudent(),
          },
        ),
      ),
    );
  }
}
