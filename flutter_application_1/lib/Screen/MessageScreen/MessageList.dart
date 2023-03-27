import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/MessageScreen/Messages.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/buildProfile.dart';
import 'package:flutter_application_1/Screen/UserProfileScreen/builUserProfile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:theme_button/theme_button.dart';

import '../../models/changetheme.dart';
import 'MessagesWidget.dart';

class MessageListScreen extends StatefulWidget {
  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  @override
  Widget build(BuildContext context) {
    bool _value = Provider.of<ColorThemeData>(context).isLight;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Text(
            'Messages',
            style: GoogleFonts.dosis(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: Theme.of(context).canvasColor),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ThemeButton(
              width: 35,
              height: 40,
              onChanged: (value) {
                Provider.of<ColorThemeData>(context, listen: false)
                    .switchTheme(value);
                //log('$value');
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid.toString())
              .collection("Message")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      print(snapshot.data!.docs[index]["with"]);

                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Messages(
                                        useruid: snapshot.data!.docs[index]
                                            ["with"],
                                        groupid: snapshot.data!.docs[index]
                                            ["groupid"])));
                          },
                          child: buildListTile(
                              snapshot.data!.docs[index]["with"],
                              snapshot.data!.docs[index]["recent"],
                              snapshot.data!.docs[index]["from"]));
                    },
                  ))
                ],
              );
            } else if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: Text('No message'),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: Text('No message'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
