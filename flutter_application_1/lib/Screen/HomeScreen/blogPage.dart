import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Tags/BlogTopic.dart';
import 'package:flutter_application_1/Widgets/flowWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

import '../../Tags/TopicTags.dart';

class BlogPage extends StatefulWidget {
  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 215, 15, 15),
      body: Column(children: [
        Row(children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 50, left: 15),
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: Text(
              'Home',
              style: GoogleFonts.dosis(color: Colors.black, fontSize: 50),
            ),
          ),
        ]),
        const Gap(44),
        Flexible(flex: 1, child: TopicTag()),
        Flexible(flex: 18, child: UsersPosts(topic[2])),
      ]),
    );
  }
}

class UsersPosts extends StatefulWidget {
  String? topic;
  UsersPosts(this.topic);
  @override
  _UsersPostsState createState() => _UsersPostsState(topic);
}

class _UsersPostsState extends State<UsersPosts> {
  String? topic;
  _UsersPostsState(this.topic);
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collectionGroup('Texts').snapshots();
  List? list;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          padding: EdgeInsets.only(top: 50, left: 10, right: 10),
          // padding: EdgeInsets.all(10),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            if (data['Topic'] == topic) {
              return FlowWidget(
                  author: data['Author'],
                  title: data['Title'],
                  desc: data['Desc'],
                  text: data['Text'],
                  url: data['Image']);
            } else {
              return FlowWidget(
                  author: data['Author'],
                  title: data['Title'],
                  desc: data['Desc'],
                  text: data['Text'],
                  url: data['Image']);
            }
            /*  return FlowWidget(
                author: data['Author'],
                title: data['Title'],
                desc: data['Desc'],
                text: data['Text'],
                url: data['Image']);*/
          }).toList(),
        );
      },
    );
  }
}
