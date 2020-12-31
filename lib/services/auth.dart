import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import '../models/error.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future signIn(String email, String password, ErrorMsg msg) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      if (!user.emailVerified) {
        signOut();
        msg.error =
            'Please verify your email address by clicking on the link sent on your registered email id.😅';
      }
      return user;
    } catch (e) {
      msg.error = e.message.toString() + '😅';
      return null;
    }
  }

  Future<void> resetPassword(String email, ErrorMsg msg) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      msg.error = 'Check your email for resetting your password';
    } catch (e) {
      msg.error = e.message.toString() + '😅';
    }
  }

  Future signUp(
      String email, String password, ErrorMsg msg, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      user.sendEmailVerification();
      msg.error =
          'Please verify your email address by clicking on the link sent on your registered email id and then try to sign in. 😅';
      await FirebaseAuth.instance.currentUser.updateProfile(
        displayName: name,
      );
      signOut();
      return user;
    } catch (e) {
      msg.error = e.message.toString() + '😅';
      return null;
    }
  }

  Future signInWithGoogle(ErrorMsg msg) async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {
      msg.error = e.message.toString() + '😅';
      return null;
    }
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Stream<User> get user {
//     return _auth.authStateChanges();
//   }

//   Future signOut() async {
//     try {
//       return await _auth.signOut();
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future signIn(String email, String password) async {
//     UserCredential result = await _auth.signInWithEmailAndPassword(
//         email: email, password: password);
//     User user = result.user;
//     if (user.emailVerified != true) {
//       print('verified');
//       return null;
//     } else
//       return user;
//   }

//   Future signUp(String email, String password) async {
//     UserCredential result = await _auth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     User user = result.user;
//     try {
//       await user.sendEmailVerification();
//       return null;
//     } catch (e) {
//       print("An error occured while trying to send email verification");
//       print(e.message);
//     }
//   }

//   Future signInWithGoogle() async {
//     final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//     final GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;

//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken,
//     );

//     final UserCredential authResult =
//         await _auth.signInWithCredential(credential);
//     final User user = authResult.user;

//     assert(!user.isAnonymous);
//     assert(await user.getIdToken() != null);

//     final User currentUser = _auth.currentUser;
//     assert(user.uid == currentUser.uid);
//     return user;
//   }
// }
