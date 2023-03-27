import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/Profile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUser extends StatefulWidget {
  @override
  State<AboutUser> createState() => _AboutUserState();
}

class _AboutUserState extends State<AboutUser> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid.toString())
        .snapshots();
    print(_usersStream);

    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // get course document

          // build list using names from sections
          return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: snapshot.data!['About'] == ""
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 200,
                              // color: Colors.amber,
                              child: Text(
                                "Birşeyler yazın",
                                style: GoogleFonts.dosis(fontSize: 22),
                              )),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0, bottom: 5, right: 15, left: 15),
                            child: Container(
                                height: 400,
                                // color: Colors.amber,
                                child: Text(
                                  snapshot.data!['About'].toString(),
                                  style: GoogleFonts.dosis(
                                      fontSize: 15,
                                      color: Theme.of(context).canvasColor),
                                )),
                          ),
                        ],
                      ),
                    ));
        } else {
          return Container();
        }
      },
    );
  }
}
