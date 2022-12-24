import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Screen/DiscvoverScreen/Searchbar.dart';
import 'package:flutter_application_1/Tags/BlogTopic.dart';
import 'package:flutter_application_1/Widgets/flowWidget.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../Tags/TopicTags.dart';
import 'DiscoverWidget.dart';

class Discover extends StatefulWidget {
  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  int current = 0;
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      /*drawer: Drawer(
          elevation: 0,
          backgroundColor: Colors.black,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Çıkış"),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Çıkış"),
              ),
              ListTile(),
            ],
          )),*/
      /* appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.brown),
        /* actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false));
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false));
            },
          ),
        ],*/
      ),*/
      body: Column(children: [
        Container(
          padding: EdgeInsets.only(top: 60, left: 10, right: 10),
          width: MediaQuery.of(context).size.width,
          height: 95,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 46, 45, 44),
                  size: 25,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchBar(),
                  ));
                },
              ),
              SizedBox(
                width: 5,
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Color.fromARGB(255, 46, 45, 44),
                  size: 25,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          padding: EdgeInsets.only(top: 0, left: 10, right: 10),
          width: MediaQuery.of(context).size.width,
          height: 110,
          child: Column(
            children: [
              Center(
                child: Text(
                  'Discover',
                  style: GoogleFonts.dosis(
                      color: Color.fromARGB(255, 10, 10, 10), fontSize: 40),
                ),
              ),
              Center(
                child: Text(
                  'New Articles',
                  style: GoogleFonts.dosis(
                      color: Color.fromARGB(255, 10, 10, 10), fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        const Gap(20),
        Flexible(flex: 2, child: TopicTag()),
        const Gap(25),
        Flexible(flex: 18, child: Posts(topic[2])),
      ]),
    );
  }
}

class Posts extends StatefulWidget {
  String? topic;
  Posts(this.topic);
  @override
  _PostsState createState() => _PostsState(topic);
}

class _PostsState extends State<Posts> {
  String? topic;
  _PostsState(this.topic);
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collectionGroup('Texts').snapshots();
  var rng = Random();

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

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StaggeredGrid.count(
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              if (data['Topic'] == topic) {
                return DiscoverWidget(
                  data: data,
                  count: rng.nextInt(3) + 1,
                );
              } else {
                return DiscoverWidget(
                  data: data,
                  count: rng.nextInt(3) + 1,
                );
              }
            }).toList(),
          ),
        );
      },
    );
  }
}
