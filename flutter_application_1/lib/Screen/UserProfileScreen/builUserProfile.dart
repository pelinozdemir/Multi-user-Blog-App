import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ProfileScreen/Profile.dart';
import 'UsersProfile.dart';

class BuildImageUser extends StatelessWidget {
  String uid;
  String username;
  BuildImageUser({required this.uid, required this.username});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(uid.toString())
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // get course document

          // build list using names from sections
          return GestureDetector(
            onTap: () {
              getUserInfo(username, context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 0, right: 10),
              child: Stack(
                fit: StackFit.loose,
                children: [
                  snapshot.data!['Profile'].toString() != null
                      ? CircleAvatar(
                          radius: 18,
                          backgroundImage: CachedNetworkImageProvider(
                              snapshot.data!['Profile'].toString()),
                        )
                      : CircleAvatar(
                          backgroundColor: Theme.of(context).canvasColor,
                        ),

                  /*  Text(snapshot.data!['Username'].toString(),
                    style: GoogleFonts.dosis(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold))*/
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<void> getUserInfo(String username, BuildContext context) async {
    var data = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username', isEqualTo: username.toString())
        .limit(1)
        .get()
        .then(
      (value) async {
        var data = await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .collection("Account")
            .doc("Following")
            .snapshots()
            .listen((event) async {
          if (event.data()!.containsKey(value.docs.first.id)) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UsersProfile(
                          uid: value.docs.first.id,
                          name: username.toString(),
                          following: true,
                        )));
          } else {
            if (value.docs.first.id == FirebaseAuth.instance.currentUser!.uid) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UsersProfile(
                            uid: value.docs.first.id,
                            name: username.toString(),
                            following: false,
                          )));
            }
          }
        });
      },
    );
  }
}

Widget buildImageCircle(String uid) {
  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(uid.toString())
      .snapshots();
  print(_usersStream);
  return StreamBuilder<DocumentSnapshot>(
    stream: _usersStream,
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        // get course document

        // build list using names from sections
        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(left: 10, top: 0, right: 10),
            child: Stack(
              fit: StackFit.loose,
              children: [
                snapshot.data!['Profile'].toString() != null
                    ? CircleAvatar(
                        radius: 40,
                        backgroundImage: CachedNetworkImageProvider(
                            snapshot.data!['Profile'].toString()),
                      )
                    : CircleAvatar(
                        backgroundColor: Theme.of(context).canvasColor,
                      ),

                /*  Text(snapshot.data!['Username'].toString(),
                    style: GoogleFonts.dosis(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold))*/
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    },
  );
}
