import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/Palette.dart';

Widget buildListTile(String uid, String recent, String from) {
  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(uid.toString())
      .snapshots();

  return StreamBuilder<DocumentSnapshot>(
    stream: _usersStream,
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        // get course document

        // build list using names from sections
        return Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: snapshot.data!['Profile'].toString() != null
                  ? CircleAvatar(
                      radius: 25,
                      backgroundImage: CachedNetworkImageProvider(
                          snapshot.data!['Profile'].toString()),
                    )
                  : CircleAvatar(
                      backgroundColor: Theme.of(context).canvasColor,
                    ),
              title: Text(
                snapshot.data!["Username"].toString(),
                style: GoogleFonts.dosis(
                    fontSize: 20, color: Theme.of(context).canvasColor),
              ),
              subtitle: Text(
                recent,
                style: GoogleFonts.dosis(
                    fontSize: 15, color: Theme.of(context).cardColor),
              ),
              trailing: from == FirebaseAuth.instance.currentUser!.uid
                  ? Icon(
                      Icons.done_all,
                      color: orange,
                      size: 17,
                    )
                  : null,
            ),
          ),
        );
      } else {
        return Container();
      }
    },
  );
}

Widget buildAppBarForMessage(
  String uid,
) {
  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(uid.toString())
      .snapshots();

  return StreamBuilder<DocumentSnapshot>(
    stream: _usersStream,
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        return AppBar(
            leading: BackButton(
              color: Theme.of(context).canvasColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(
                      snapshot.data!['Profile'].toString()),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  snapshot.data!["Username"].toString(),
                  style: GoogleFonts.dosis(fontSize: 20),
                )
              ],
            ));
      } else {
        return Container();
      }
    },
  );
}
