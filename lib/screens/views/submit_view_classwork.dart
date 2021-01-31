import 'package:classroom/screens/views/upload_assignment.dart';
import 'package:classroom/screens/views/upload_notes.dart';
import 'package:classroom/services/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

class SubmitClasswork extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  SubmitClasswork(this.classData);
  @override
  _SubmitClassworkState createState() => _SubmitClassworkState();
}

class _SubmitClassworkState extends State<SubmitClasswork>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> page = [
      new Expanded(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(widget.classData['code'])
                .doc('Notes')
                .collection('Notes')
                .snapshots(),
            builder: (context, announcementSnapshot) {
              return announcementSnapshot.hasData
                  ? ListView.builder(
                      itemCount: announcementSnapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot announcementData =
                            announcementSnapshot.data.documents[index];
                        print(announcementData.data());

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  announcementData.data()['topic'] != null
                                      ? announcementData.data()['topic']
                                      : 'Loading',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                FlatButton(
                                  color: Colors.amber,
                                  child: Text('Open notes'),
                                  onPressed: () async {
                                    if (await canLaunch(
                                        announcementData.data()['url']))
                                      launch(announcementData.data()['url']);
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
      ),
      new Expanded(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(widget.classData['code'])
                .doc('assignments')
                .collection('assignments')
                .snapshots(),
            builder: (context, announcementSnapshot) {
              return announcementSnapshot.hasData
                  ? ListView.builder(
                      itemCount: announcementSnapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot announcementData =
                            announcementSnapshot.data.documents[index];
                        print(announcementData.data());

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      announcementData.data()[
                                                  'topic + teacher copy'] !=
                                              null
                                          ? announcementData
                                              .data()['topic + teacher copy']
                                          : 'Loading',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      announcementData.data()[
                                                  'dueDate + teacher copy'] !=
                                              null
                                          ? 'Due date ' +
                                              announcementData
                                                  .data()[
                                                      'dueDate + teacher copy']
                                                  .toString()
                                                  .substring(0, 10)
                                          : 'Loading',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                FlatButton(
                                  color: Colors.amber,
                                  child: Text('Open Assignment'),
                                  onPressed: () async {
                                    if (await canLaunch(
                                        announcementData.data()['url']))
                                      launch(announcementData.data()['url']);
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
                                // Text('123')
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: Loader());
            }),
      ),
    ];
    final user = Provider.of<User>(context);
    var imgURL;
    if (user == null) {
      imgURL =
          'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    } else {
      imgURL = user.photoURL != null
          ? user.photoURL
          : 'https://cdn3.iconfinder.com/data/icons/user-interface-web-1/550/web-circle-circular-round_54-512.png';
    }
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            AppBar().preferredSize.height,
        child: Column(
          children: [
            UserInfo(imgURL: imgURL, user: user, classData: widget.classData),
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
                          'View uploaded notes',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                    onPressed: () {
                      setState(() {
                        _index = 0;
                      });
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
                          'View assignments',
                          style: TextStyle(color: Colors.white),
                        )),
                    onPressed: () {
                      setState(() {
                        _index = 1;
                      });
                    },
                  ),
                )
              ],
            ),
            page[_index]
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key key,
    @required this.imgURL,
    @required this.user,
    @required this.classData,
  }) : super(key: key);

  final imgURL;
  final User user;
  final Map classData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
          child: Text(
            'You are currently signed in as..',
            style: GoogleFonts.roboto(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
              child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill, image: new NetworkImage(imgURL)))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.displayName,
                      style:
                          GoogleFonts.questrial(fontWeight: FontWeight.bold)),
                  Text(user.email,
                      style:
                          GoogleFonts.questrial(fontWeight: FontWeight.w100)),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Divider(),
        ),
      ],
    );
  }
}
