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
  final CollectionReference myClassCollection;
  final String uid;
  MyClassDatabase(this.uid, this.myClassCollection);
  Future createClass(subjectName, code, professorName, email) async {
    return await myClassCollection.add({
      'subjectName': subjectName,
      'code': code,
      'professorName': professorName,
      'email': email,
    });
  }

  Future updateClass(MyClasses data) async {
    return await myClassCollection.add({
      'subjectName': data.subjectName,
      'code': data.subjectName,
      'professorName': data.professorName,
      'email': data.email,
      'students': data.students,
      'announcements': data.announcements,
      'assignments': data.assignment,
      'lectures': data.lectures
    });
  }
}
