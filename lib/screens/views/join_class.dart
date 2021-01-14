import 'package:classroom/services/my_classes.dart';
import 'package:flutter/material.dart';

class JoinClass extends StatelessWidget {
  static const routeName = '/join-class';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final rollNum = TextEditingController();
  final code = TextEditingController();
  final name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join a class')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: rollNum,
                      decoration:
                          InputDecoration(hintText: 'Enter roll number'),
                    ),
                    TextFormField(
                      controller: code,
                      decoration: InputDecoration(hintText: 'Enter code'),
                    ),
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(hintText: 'Enter name'),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        String str = code.text;
                        int index;
                        for (int i = 0; i < str.length; ++i) {
                          if (str[i] == '.' &&
                              str[i + 1] == 'c' &&
                              str[i + 2] == 'o' &&
                              str[i + 3] == 'm') index = i + 3;
                        }
                        String teacherId = str.substring(0, index + 1);
                        var db = JoinClassDataBase(
                            code.text, rollNum.text, teacherId, name.text);
                        db.JoinClass();
                        // List<Map<String, String>> studentList = new List();
                        // studentList.add({
                        //   'studentName': 'studentName',
                        //   'rollNum': 'rollNum'
                        // });
                        // print(studentList);
                      },
                      child: Text('Join the class'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
