import 'package:classroom/services/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/database.dart';

class UpcomingClassesStudent extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  UpcomingClassesStudent(this.classData);

  @override
  _UpcomingClassesStudentState createState() => _UpcomingClassesStudentState();
}

class _UpcomingClassesStudentState extends State<UpcomingClassesStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(widget.classData['code'])
              .doc('Upcoming classes')
              .collection('Upcoming classes')
              .snapshots(),
          builder: (context, classSnapshot) {
            return classSnapshot.hasData
                ? ListView.builder(
                    itemCount: classSnapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot lectureData =
                          classSnapshot.data.documents[index];
                      print(lectureData.data());
                      final url = TextEditingController();
                      url.text = lectureData.data()['url'];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Topic: ' +
                                    lectureData.data()['topics'].toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                'Date: ' +
                                    (lectureData.data()['date'].toString())
                                        .substring(0, 10),
                                style: GoogleFonts.montserrat(fontSize: 15),
                              ),
                              Text('Time: ' +
                                  lectureData
                                      .data()['time']
                                      .toString()
                                      .substring(10, 15)),
                              TextFormField(
                                style: TextStyle(color: Colors.blue),
                                controller: url,
                                readOnly: true,
                              ),
                              FlatButton(
                                color: Colors.amber,
                                child: Text('Open url'),
                                onPressed: () async {
                                  if (await canLaunch(url.text))
                                    launch(url.text);
                                  else
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        backgroundColor:
                                            Color.fromRGBO(219, 22, 47, 1),
                                        content: Text(
                                            "Can't open the provided link",
                                            style: TextStyle(
                                                color: Colors.white))));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: Loader());
          }),
    );
  }
}
