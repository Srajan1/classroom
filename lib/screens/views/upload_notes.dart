import 'package:classroom/services/loading.dart';
import 'package:classroom/widgets/formFields.dart';
import 'package:flutter/material.dart';
import '../../services/database.dart';

class Notes extends StatefulWidget {
  String code;
  Notes(this.code);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final topic = TextEditingController();
  String msg = ' ';
  final url = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FlatButton(
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
                                var db = PostNotes(
                                    widget.code, topic.text, url.text);
                                await db.postNote();
                                topic.text = '';
                                url.text = '';
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  msg = 'Notes are uploaded';
                                  loading = false;
                                });
                              }
                            },
                          ),
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
