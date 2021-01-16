import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class Students extends StatelessWidget {
  Map<dynamic, dynamic> classData;
  Students(this.classData);
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
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            AppBar().preferredSize.height,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 10),
                  child: Text(
                    'You are currently signed in as..',
                    style: GoogleFonts.roboto(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 10),
                      child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(imgURL)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.displayName,
                              style: GoogleFonts.questrial(
                                  fontWeight: FontWeight.bold)),
                          Text(user.email,
                              style: GoogleFonts.questrial(
                                  fontWeight: FontWeight.w100)),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Divider(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Professor',
                          style: GoogleFonts.questrial(
                              fontWeight: FontWeight.bold)),
                      Text(classData['profName'].toString().toUpperCase(),
                          style: GoogleFonts.questrial(
                              fontWeight: FontWeight.w100, fontSize: 30)),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 28,
                left: 28,
                right: 28,
              ),
              child: Divider(),
            ),
            Expanded(
              // height: 200,
              child: ListView.builder(
                itemCount: classData['studentList'].length,
                itemBuilder: (context, index) {
                  String rollNum = classData['studentList'][index]['rollNum'],
                      name = classData['studentList'][index]['studentName'],
                      email = classData['studentList'][index]['email'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Column(
                                children: [
                                  Text(rollNum,
                                      style: GoogleFonts.questrial(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Divider(),
                                  Text(name.toUpperCase(),
                                      style: GoogleFonts.questrial(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 20)),
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () async {
                                final mailtoLink = Mailto(
                                  to: [email],
                                  // cc: ['cc1@example.com', 'cc2@example.com'],
                                  // subject: 'mailto example subject',
                                  // body: 'mailto example body',
                                );
                                // Convert the Mailto instance into a string.
                                // Use either Dart's string interpolation
                                // or the toString() method.
                                await launch('$mailtoLink');
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.email,
                                    color: Colors.red,
                                  ),
                                  Text('Contact your student',
                                      style: GoogleFonts.openSans(
                                          fontSize: 10, color: Colors.grey))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
