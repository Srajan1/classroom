import 'package:classroom/models/announcement.dart';
import 'package:classroom/models/assignment.dart';
import 'package:classroom/models/lectures.dart';
import 'package:classroom/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final code, rollNum, collName, studentName;
  JoinClassDataBase(this.code, this.rollNum, this.collName, this.studentName);
  Future JoinClass() async {
    final teacher = FirebaseFirestore.instance.collection(collName);
    Student student = Student(studentName, rollNum);

    DocumentSnapshot classRoom = await teacher.doc(code).get();
    print(classRoom.data());
    List<dynamic> studentList = classRoom.data()['studentList'];
    studentList.add({'studentName': studentName, 'rollNum': rollNum});
    teacher.doc(code).update({"studentList": studentList});
    print(studentList);
  }
}
