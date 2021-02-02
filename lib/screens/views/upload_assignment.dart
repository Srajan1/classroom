import 'package:classroom/services/loading.dart';
import 'package:classroom/widgets/formFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database.dart';

class UploadAssignment extends StatefulWidget {
  final code;
  String email;
  UploadAssignment(this.code, this.email);

  @override
  _UploadAssignmentState createState() => _UploadAssignmentState();
}

class _UploadAssignmentState extends State<UploadAssignment> {
  final topic = TextEditingController();
  String msg = ' ';
  final url = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loader()
        : Scaffold(
            appBar: AppBar(
              title: Text('notes'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    formField(topic, 'Topic', context),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'You can upload files online like on google drive/ondrive and paste the url here, down below',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    formField(url, 'Link of file', context),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FlatButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          'Due date ' +
                              "${selectedDate.toLocal()}".split(' ')[0],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  )),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )),
                          onPressed: () {
                            topic.text = '';
                            url.text = '';
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        FlatButton(
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white)),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                'Post',
                                style: TextStyle(color: Colors.white),
                              )),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              var db = PostAssignment(
                                  widget.code,
                                  topic.text,
                                  url.text,
                                  selectedDate.toLocal(),
                                  "Teacher's copy");
                              await db.postNote();
                              print(widget.email);
                              setState(() {
                                msg = 'Assignment is uploaded';
                                loading = false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Text(
                      msg,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
