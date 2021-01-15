import 'package:classroom/constants/constants.dart';
import 'package:classroom/models/error.dart';
import 'package:classroom/services/database.dart';
import 'package:classroom/screens/views/created_classes.dart';
import 'package:classroom/services/drawer.dart';
import 'package:classroom/services/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/loader.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';

class CreateClass extends StatefulWidget {
  static const routeName = '/create-class';

  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final subjectName = TextEditingController();

  final professorName = TextEditingController();

  final batch = TextEditingController();
  String code;
  bool _loading = false, created = false;
  String msg = ' ';
  ErrorMsg err = ErrorMsg(' ');
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String coll = user.email;
    final CollectionReference myClassCollection =
        FirebaseFirestore.instance.collection(coll);
    final db = MyClassDatabase(user.uid, myClassCollection);
    return _loading
        ? Loader()
        : Scaffold(
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
                          formField(context, subjectName, 'Name of subject'),
                          formField(
                              context, professorName, 'Name of professor'),
                          formField(context, batch, 'Semester/class'),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              msg,
                              style: TextStyle(
                                  color: Colors.red[400], fontSize: 20),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Theme.of(context).accentColor,
                              color: Theme.of(context).accentColor,
                              child: Builder(builder: (context) {
                                return FlatButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      await db.createClass(
                                          subjectName.text,
                                          batch.text,
                                          professorName.text,
                                          user.email,
                                          err,
                                          user.email +
                                              subjectName.text +
                                              batch.text);

                                      setState(() {
                                        _loading = false;
                                        created = true;
                                        code = user.email +
                                            subjectName.text +
                                            batch.text;
                                        msg = err.error;
                                        Future.delayed(
                                            const Duration(milliseconds: 3000),
                                            () {
                                          setState(() {
                                            msg = ' ';
                                          });
                                        });
                                      });
                                      subjectName.text = '';
                                      batch.text = '';
                                      professorName.text = '';
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      'Create class',
                                      style: kTitleStyle,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          CopyCode(created: created, code: code),
                          Container(
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Theme.of(context).primaryColor,
                              color: Theme.of(context).primaryColor,
                              child: Builder(builder: (context) {
                                return FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        CreatedClasses.routeName,
                                        arguments: user.email);
                                  },
                                  child: Center(
                                    child: Text(
                                      'View all your classes',
                                      style: kTitleStyle,
                                    ),
                                  ),
                                );
                              }),
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

  TextFormField formField(BuildContext context, controller, hint) {
    return TextFormField(
      validator: (value) => value.isEmpty ? 'Please enter a value' : null,
      controller: controller,
      decoration: InputDecoration(
          labelText: hint,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor))),
    );
  }
}

class CopyCode extends StatelessWidget {
  const CopyCode({
    Key key,
    @required this.created,
    @required this.code,
  }) : super(key: key);

  final bool created;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          children: [
            Text(
                'Copy the following code and send to your students, so they can join your class'),
            FlatButton(
              onPressed: created
                  ? () async {
                      ClipboardData data = ClipboardData(text: (code));
                      await Clipboard.setData(data);
                      print(code);
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Color.fromRGBO(219, 22, 47, 1),
                          content: Text("Code copied😁",
                              style: TextStyle(color: Colors.white))));
                    }
                  : null,
              child: Text('Copy'),
            ),
          ],
        ),
      ),
    );
  }
}
