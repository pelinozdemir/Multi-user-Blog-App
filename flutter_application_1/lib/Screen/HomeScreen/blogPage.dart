import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/buildProfile.dart';
import 'package:flutter_application_1/Screen/UserProfileScreen/builUserProfile.dart';
import 'package:flutter_application_1/Tags/BlogTopic.dart';
import 'package:flutter_application_1/Widgets/flowWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:theme_button/theme_button.dart';

import '../../Tags/TopicTags.dart';
import '../../models/changetheme.dart';

class BlogPage extends StatefulWidget {
  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<String> following = [];
  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Account')
      .doc('Following')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.dosis(
              fontSize: 35,
              fontWeight: FontWeight.w600,
              textStyle: TextStyle(color: Theme.of(context).canvasColor)),
        ),
        leading: Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ThemeButton(
            width: 10,
            height: 10,
            onChanged: (value) {
              Provider.of<ColorThemeData>(context, listen: false)
                  .switchTheme(value);
              //log('$value');
            },
          ),
        ),
        /*IconButton(
          icon: Provider.of<ColorThemeData>(context).isGreen
              ? Icon(CupertinoIcons.moon_fill)
              : Icon(CupertinoIcons.sun_max_fill),
              
          onPressed: () {
            setState(() {
              Provider.of<ColorThemeData>(context, listen: false)
                  .switchTheme(true);
            });
          },
        ),*/
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).canvasColor,
              size: 25,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/search');
            },
          ),
          SizedBox(
            width: 5,
          ),
          buildImageSmall()
        ],
      ),
      //  backgroundColor: Color.fromARGB(255, 215, 15, 15),
      body: _usersStream == null
          ? Center(
              child: Text('none'),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: _usersStream,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                // print("BOK");
                Map<String, dynamic>? followingdata =
                    snapshot.data?.data() as Map<String, dynamic>?;
                //   print(followingdata);
                return Column(children: [
                  const Gap(10),
                  Flexible(
                      flex: 38,
                      child: UsersPosts(followingdata: followingdata)),
                ]);
              },
            ),
    );
  }
}

class UsersPosts extends StatefulWidget {
  Map<String, dynamic>? followingdata;
  UsersPosts({required this.followingdata});
  @override
  _UsersPostsState createState() =>
      _UsersPostsState(followingdata: followingdata);
}

class _UsersPostsState extends State<UsersPosts> {
  Map<String, dynamic>? followingdata;

  _UsersPostsState({required this.followingdata});
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Posts').snapshots();
  List? list;
  @override
  Widget build(BuildContext context) {
    // print(followingdata!.keys);
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            // padding: EdgeInsets.all(10),
            children: snapshot.data!.docs.map((e) {
              print(e.id);
              if (followingdata!.keys.contains(e.id)) {
                return FlowWidget(id: e.id);
              } else {
                return Center();
              }
              //return Container();
            }).toList());
      },
    );
  }
}
