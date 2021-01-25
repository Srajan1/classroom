import 'package:classroom/models/error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyClassDatabase {
  final CollectionReference teacher;
  final String uid;
  MyClassDatabase(this.uid, this.teacher);
  Future createClass(
      subjectName, batch, professorName, email, err, code) async {
    FirebaseFirestore.instance
        .collection('allClasses')
        .doc(code)
        .set({'exists': true});
    List<dynamic> studentList = new List();
    return teacher.doc(code).set({
      'profName': professorName,
      'subName': subjectName,
      'email': email,
      'batch': batch,
      'code': code,
      'studentList': studentList
    }).then((value) {
      List<dynamic> announcement;
      final classCollection = FirebaseFirestore.instance.collection(code);
      classCollection.doc('Announcements').set({});
      classCollection.doc('assignments').set({});
      classCollection.doc('Upcoming classes').set({});
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
      var allClasses = FirebaseFirestore.instance.collection('allClasses');
      if (allClasses.doc(code).get() != null) {
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
      } else {
        print('does not exist');
        error.error = 'Class does not exist';
      }
    }
  }
}

class ScheduleClass {
  var url, topics, code;
  var date;
  var time;
  ErrorMsg error = new ErrorMsg(' ');
  ScheduleClass(
      {this.date, this.time, this.topics, this.url, this.error, this.code});
  Future scheduleClass() async {
    if (topics == '') topics = 'Unnamed topic';
    var classCollection = FirebaseFirestore.instance.collection(code);
    await classCollection
        .doc('Upcoming classes')
        .collection('Upcoming classes')
        .doc()
        .set({
      'url': url,
      'topics': topics,
      'time': time.toString(),
      'date': date.toString()
    }).then((_) {
      error.error = 'class created';
    }).catchError((err) {
      error.error = err.toString();
    });
  }
}

class ViewScheduledClasses {
  var code;
  ViewScheduledClasses(this.code);
  Future ViewClasses() async {
    var collName = FirebaseFirestore.instance.collection(code);
    DocumentSnapshot upcomingClass = await collName
        .doc('Upcoming classes')
        .collection('topic')
        .doc()
        .get()
        .then((snapshot) {
      print(snapshot.data());
    }).catchError((err) {
      print(err);
    });
  }
}
