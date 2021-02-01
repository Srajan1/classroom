import 'package:classroom/services/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/database.dart';

class Announcements extends StatefulWidget {
  Map<dynamic, dynamic> classData;
  Announcements(this.classData);
  static const routeName = '/announcements';

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  bool _loading = false;

  final announcement = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  maxLines: 3,
                  validator: ((value) =>
                      value.isEmpty ? 'Post can\'t be empty' : null),
                  controller: announcement,
                  decoration: InputDecoration(
                    hintText: 'title',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
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
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                  onPressed: () {
                    announcement.text = '';
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
                        _loading = true;
                      });
                      var db = MakeAnnouncement(widget.classData['code'],
                          user.displayName, announcement.text);
                      await db.makeAnnouncement();
                      setState(() {
                        FocusScope.of(context).unfocus();
                        announcement.text = '';
                        _loading = false;
                      });
                    }
                  },
                )
              ],
            ),
            ListOfAnnouncements(classData: widget.classData)
          ],
        ),
      ),
    );
  }
}

class ListOfAnnouncements extends StatelessWidget {
  const ListOfAnnouncements({
    Key key,
    @required this.classData,
  }) : super(key: key);

  final Map classData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(classData['code'])
              .doc('Announcements')
              .collection('announcements')
              .snapshots(),
          builder: (context, announcementSnapshot) {
            return announcementSnapshot.hasData
                ? ListView.builder(
                    itemCount: announcementSnapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot announcementData =
                          announcementSnapshot.data.documents[index];
                      print(announcementData.data());

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      announcementData.data()['postedBy'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(announcementData.data()['time']),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        announcementData.data()['post'],
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(child: Loader());
          }),
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
