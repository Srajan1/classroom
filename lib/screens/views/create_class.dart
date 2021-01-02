import 'package:classroom/constants/constants.dart';
import 'package:classroom/models/my_classes.dart';
import 'package:classroom/services/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

class CreateClass extends StatelessWidget {
  static const routeName = '/create-class';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final subjectName = TextEditingController();
  final professorName = TextEditingController();
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String coll = 'myClasses' + user.uid;
    final CollectionReference myClassCollection =
        FirebaseFirestore.instance.collection(coll);
    final db = MyClassDatabase(user.uid, myClassCollection);
    email.text = user.email;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Colors.white,
        title: Text(
          'Create class',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
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
                      validator: (value) =>
                          value.isEmpty ? 'Please enter a value' : null,
                      controller: subjectName,
                      decoration: InputDecoration(
                          labelText: 'Name of subject',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor))),
                    ),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? 'Please enter a value' : null,
                      controller: professorName,
                      decoration: InputDecoration(
                          labelText: 'Name of the professor',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor))),
                    ),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? 'Please enter a value' : null,
                      controller: email,
                      decoration: InputDecoration(
                          labelText: 'Email of the professor',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor))),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Theme.of(context).accentColor,
                        color: Theme.of(context).accentColor,
                        child: FlatButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await db.createClass(
                                  subjectName.text,
                                  subjectName.text + user.email,
                                  professorName.text,
                                  user.email);
                            }
                          },
                          child: Center(
                            child: Text(
                              'Create class',
                              style: kTitleStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Theme.of(context).accentColor,
                        color: Theme.of(context).accentColor,
                        child: FlatButton(
                          onPressed: () {
                            // Phoenix.rebirth(context);
                            // print('Clicked');
                          },
                          child: Center(
                            child: Text(
                              'Restart',
                              style: kTitleStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
