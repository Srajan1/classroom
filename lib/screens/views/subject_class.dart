import 'package:classroom/screens/views/class_announcements.dart';
import 'package:classroom/screens/views/students.dart';
import 'package:flutter/material.dart';

class SubjectClass extends StatefulWidget {
  static const routeName = '/subject-class';

  @override
  _SubjectClassState createState() => _SubjectClassState();
}

class _SubjectClassState extends State<SubjectClass> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> classData = ModalRoute.of(context).settings.arguments;
    final tabs = [
      Announcements(classData),
      Center(child: Text('Classwork')),
      Students(classData),
      Center(
        child: Text('upcoming classes'),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          classData['subName'].toString(),
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Colors.white,
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.stream,
              ),
              label: 'announcement'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.class__rounded,
              ),
              label: 'classwork'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
              ),
              label: 'People'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.meeting_room,
              ),
              label: 'upcoming classes'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
