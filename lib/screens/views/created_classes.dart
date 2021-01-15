import 'package:classroom/constants/constants.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatedClasses extends StatelessWidget {
  static const routeName = '/my-classes';
  List<Color> colorList = [
    Color.fromRGBO(255, 173, 173, 1),
    Color.fromRGBO(238, 239, 32, 1),
    Color.fromRGBO(200, 231, 255, 1),
    Color.fromRGBO(242, 232, 207, 1),
    Color.fromRGBO(155, 246, 255, 1),
    // Color.fromRGBO(160, 196, 255, 1),
    Color.fromRGBO(189, 178, 255, 1),
    Color.fromRGBO(255, 198, 255, 1),
  ];
  @override
  Widget build(BuildContext context) {
    var colorIndex = -1;
    final String collName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'All your class',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(collName).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                colorIndex += 1;
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(20.0),
                  color: Colors.white,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 8),
                        child: Text(
                          'Subject Name: ' + document.data()['subName'],
                          style: kPageTitleStyleBlack,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Year/semester: ' + document.data()['batch'],
                          style: kSubtitleStyle,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Theme.of(context).accentColor,
                              color: colorList[colorIndex % colorList.length],
                              child: Builder(builder: (context) {
                                return FlatButton(
                                  onPressed: () {},
                                  child: Center(
                                    child: Text(
                                      'View class',
                                      style: GoogleFonts.questrial(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Theme.of(context).accentColor,
                              color: colorList[colorIndex % colorList.length],
                              child: Builder(builder: (context) {
                                return FlatButton(
                                  onPressed: () async {
                                    ClipboardData data = ClipboardData(
                                        text: (document.data()['code']));
                                    await Clipboard.setData(data);
                                    print(document.data()['code']);
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        backgroundColor:
                                            Color.fromRGBO(219, 22, 47, 1),
                                        content: Text("Code copied😁",
                                            style: TextStyle(
                                                color: Colors.white))));
                                  },
                                  child: Center(
                                    child: Text(
                                      'Copy code',
                                      style: GoogleFonts.questrial(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}

class Arguments {
  final String collectionName;

  Arguments(this.collectionName);
}
