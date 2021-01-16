import 'package:classroom/models/announcement.dart';
import 'package:classroom/models/assignment.dart';
import 'package:classroom/models/error.dart';
import 'package:classroom/models/lectures.dart';
import 'package:classroom/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MyClasses {
  String subjectName;
  String code;
  String professorName;
  String email;
  List<Student> students;
  List<Announcement> announcements;
  List<Assignment> assignment;
  List<Lectures> lectures;
}

class MyClassDatabase {
  final CollectionReference teacher;
  final String uid;
  MyClassDatabase(this.uid, this.teacher);
  Future createClass(
      subjectName, batch, professorName, email, err, code) async {
    List<dynamic> studentList = new List();
    return teacher.doc(code).set({
      'profName': professorName,
      'subName': subjectName,
      'email': email,
      'batch': batch,
      'code': code,
      'studentList': studentList
    }).then((value) {
      print("User Added");
      err.error = 'Class created';
    }).catchError((error) {
      err.error = "Failed to add user: $error";
    });
  }
}

class JoinClassDataBase {
  String code, rollNum, studentName, email;
  var collName;
  ErrorMsg error;
  JoinClassDataBase(this.code, this.rollNum, this.collName, this.studentName,
      this.email, this.error);
  Future JoinClass() async {
    if (code.contains(email)) {
      error.error = 'You know you are the teacher of this class. Right?. 🤣🤣';
    } else {
      final teacher = FirebaseFirestore.instance.collection(collName);
      final studentCollection =
          FirebaseFirestore.instance.collection('student ' + email);
      DocumentSnapshot classRoom = await teacher.doc(code).get();
      DocumentSnapshot myClasses = await studentCollection.doc(code).get();
      if (myClasses.data() != null)
        error.error = 'Why are you trying to enroll twice? 😑🙄';
      else {
        print(classRoom.data());
        List<dynamic> studentList = classRoom.data()['studentList'];
        studentList.add(
            {'studentName': studentName, 'rollNum': rollNum, 'email': email});
        teacher.doc(code).update({"studentList": studentList});
        print(studentList);
        error.error = 'You\'ve successfully joined the class. 🌟🌟';
        return studentCollection.doc(code).set({
          'code': code,
        });
      }
    }
  }
}
