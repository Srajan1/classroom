import 'package:classroom/constants/constants.dart';
import 'package:classroom/models/error.dart';
import 'package:classroom/services/database.dart';
import 'package:classroom/services/loading.dart';
import 'package:classroom/widgets/formFields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpcomingClasses extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  UpcomingClasses(this.classData);

  @override
  _UpcomingClassesState createState() => _UpcomingClassesState();
}

class _UpcomingClassesState extends State<UpcomingClasses> {
  String msg =
      'Schedule a class, all of your students will be informed about it.';
  bool _loading = false;
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

  TimeOfDay _time = TimeOfDay.now();

  Future<Null> selectTime(context) async {
    _time = TimeOfDay.now();
    TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);

    setState(() {
      _time = picked;
    });
    print(_time);
  }

  final url = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final topics = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loader()
        : Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height -
                  kBottomNavigationBarHeight -
                  AppBar().preferredSize.height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 10),
                    child: Text(
                      msg,
                      style: GoogleFonts.questrial(
                        fontSize: 23.0,
                        // fontWeight: FontWeight.w900,
                        color: Colors.black,
                        wordSpacing: 2.5,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28),
                          child: formField(url, 'Meeting url', context),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28),
                          child: formField(topics, 'Lecture topic', context),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: FlatButton(
                            onPressed: () => _selectDate(context),
                            child: Text(
                              'Selected date ' +
                                  "${selectedDate.toLocal()}".split(' ')[0],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: FlatButton(
                            onPressed: () => selectTime(context),
                            child: Text(_time == null
                                ? 'Selected time'
                                : 'Selected time' +
                                    _time.format(context).toString()),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Theme.of(context).accentColor,
                            color: Theme.of(context).accentColor,
                            child: Builder(builder: (context) {
                              return FlatButton(
                                onPressed: () async {
                                  setState(() {
                                    _loading = true;
                                  });
                                  if (_formKey.currentState.validate()) {
                                    ErrorMsg error = new ErrorMsg(' ');
                                    var db = ScheduleClass(
                                        code: widget.classData['code'],
                                        date: selectedDate.toLocal(),
                                        error: error,
                                        time: _time,
                                        topics: topics.text,
                                        url: url.text);
                                    await db.scheduleClass();
                                    setState(() {
                                      url.text = '';
                                      topics.text = '';
                                      _loading = false;
                                      msg = error.error;
                                    });
                                  }
                                },
                                child: Text(
                                  'Schedule class',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                ],
              ),
            ),
          );
  }
}
