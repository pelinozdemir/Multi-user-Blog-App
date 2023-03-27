import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Colors/Palette.dart';

Widget account(String docname, String fieldname, String uid) {
  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(uid.toString())
      .collection('Account')
      .doc('followNumbers')
      .snapshots();

  return StreamBuilder<DocumentSnapshot>(
    stream: _usersStream,
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        return Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              snapshot.data![docname].toString() != null
                  ? Text(
                      snapshot.data![docname].toString(),
                      style: GoogleFonts.dosis(
                          color: Theme.of(context).canvasColor, fontSize: 18),
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                width: 5,
              ),
              Text(
                fieldname,
                style: GoogleFonts.dosis(
                    color: Theme.of(context).canvasColor, fontSize: 14),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    },
  );

  // print(useruid);
}

Widget buildButton(List<Widget> view, BuildContext context) {
  return Container(
    child: ContainedTabBarView(
      callOnChangeWhileIndexIsChanging: true,
      initialIndex: 0,
      tabBarProperties: TabBarProperties(
        padding: EdgeInsets.only(left: 10, right: 10),
        width: 180,
        position: TabBarPosition.top,
        // indicator: I,
        indicatorColor: darkOrange,
        indicatorSize: TabBarIndicatorSize.tab,
        alignment: TabBarAlignment.start,
        indicatorPadding: EdgeInsets.all(0),
        indicatorWeight: 1.2,
      ),
      tabBarViewProperties:
          const TabBarViewProperties(dragStartBehavior: DragStartBehavior.down),
      tabs: [
        Text(
          'Blog',
          style: GoogleFonts.dosis(
              color: Theme.of(context).cardColor, fontSize: 17),
        ),
        Text(
          'About',
          style: GoogleFonts.dosis(
              color: Theme.of(context).cardColor, fontSize: 17),
        ),
      ],
      views: view,
      onChange: (index) => print(index),
    ),
  );
}

setText(String uid) {
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
        return Container(
          margin: EdgeInsets.only(right: 20, left: 20),
          child: snapshot.data!['Username'].toString() != null
              ? Text(
                  snapshot.data!['Username'].toString(),
                  style: GoogleFonts.dosis(
                      color: Theme.of(context).cardColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                )
              : CircularProgressIndicator(),
        );
      } else {
        return Container();
      }
    },
  );
}

buildDivider() {
  return Container(
      height: 5,
      child: Icon(
        Icons.star_purple500_outlined,
        size: 12,
      ));
}
