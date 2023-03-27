import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/Palette.dart';

Widget buildImage() {
  User? user = FirebaseAuth.instance.currentUser;
  print(user!.uid.toString());
  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid.toString())
      .snapshots();
  print(_usersStream);
  return StreamBuilder<DocumentSnapshot>(
    stream: _usersStream,
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        // get course document

        // build list using names from sections
        return Container(
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
        );
      } else {
        return Container();
      }
    },
  );
}

Widget buildImageSmall() {
  User? user = FirebaseAuth.instance.currentUser;
  print(user!.uid.toString());
  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid.toString())
      .snapshots();
  print(_usersStream);
  return StreamBuilder<DocumentSnapshot>(
    stream: _usersStream,
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        // get course document

        // build list using names from sections
        return Container(
          margin: EdgeInsets.only(left: 10, top: 10, right: 25),
          child: Stack(
            fit: StackFit.loose,
            children: [
              snapshot.data!['Profile'].toString() != null
                  ? CircleAvatar(
                      radius: 20,
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
        );
      } else {
        return Container();
      }
    },
  );
}

buildIcon(BuildContext context) => buildCircle(
      all: 3,
      color: Colors.white,
      child: buildCircle(
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
          all: 8,
          color: lightBlue),
    );

Widget buildCircle(
        {required Widget child, required double all, required Color color}) =>
    ClipOval(
        child: Container(
      padding: EdgeInsets.all(all),
      child: child,
      color: color,
    ));
