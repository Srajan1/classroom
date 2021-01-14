import 'package:classroom/constants/constants.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<Color> colorList = [
  // Color.fromRGBO(255, 173, 173, 1),
  Color.fromRGBO(0, 187, 249, 0),
  Color.fromRGBO(200, 231, 255, 0),
  Color.fromRGBO(202, 255, 191, 0),
  Color.fromRGBO(155, 246, 255, 0),
  // Color.fromRGBO(160, 196, 255, 1),
  Color.fromRGBO(189, 178, 255, 0),
  Color.fromRGBO(255, 198, 255, 0),
];

class CreatedClasses extends StatelessWidget {
  static const routeName = '/my-classes';

  @override
  Widget build(BuildContext context) {
    final String collName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('Your classes'),
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
                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(20.0),
                  color: colorList[Random().nextInt(colorList.length)],
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
                              color: Theme.of(context).accentColor,
                              child: Builder(builder: (context) {
                                return FlatButton(
                                  onPressed: () {},
                                  child: Center(
                                    child: Text(
                                      'View class',
                                      style: kTitleStyle,
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
                              color: Theme.of(context).accentColor,
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
                                      style: kTitleStyle,
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
