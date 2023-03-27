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
import 'package:flutter_application_1/models/changetheme.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:theme_button/theme_button.dart';
import '../../Tags/TopicTags.dart';
import 'DiscoverWidget.dart';

class Discover extends StatefulWidget {
  int topicindex;
  Discover({required this.topicindex});
  @override
  State<Discover> createState() => _DiscoverState(topicindex: topicindex);
}

class _DiscoverState extends State<Discover> {
  int topicindex;
  _DiscoverState({required this.topicindex});
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool _value = Provider.of<ColorThemeData>(context).isLight;

    return Scaffold(
      appBar: AppBar(
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
        ],
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.only(top: 8, left: 10, right: 10),
          margin: EdgeInsets.only(bottom: 5),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Column(
            children: [
              Center(
                child: Text(
                  'Discover',
                  style: GoogleFonts.dosis(
                      color: Theme.of(context).canvasColor,
                      fontSize: 40,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Gap(10),
              Center(
                child: Text(
                  'New Articles',
                  style: GoogleFonts.dosis(
                      color: Theme.of(context).cardColor, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const Gap(18),
        Flexible(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            padding: EdgeInsets.all(8),
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        topicindex = index;
                      });
                    },
                    child: AnimatedContainer(
                      margin: EdgeInsets.all(2),
                      padding: EdgeInsets.all(1),
                      width: topicindex == index ? 90 : 100,
                      height: topicindex == index ? 16 : 18,
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: topicindex == index
                            ? Theme.of(context).canvasColor
                            : Colors.transparent,
                        borderRadius: topicindex == index
                            ? BorderRadius.circular(20)
                            : BorderRadius.circular(10),
                        border: topicindex == index
                            ? Border.all(color: darkBlue, width: 2)
                            : null,
                      ),
                      child: Center(
                        //style: TextStyle(fontSize: 50),

                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            textAlign: TextAlign.center,
                            topic[index],
                            style: GoogleFonts.dosis(
                                fontWeight: FontWeight.w500,
                                color: topicindex == index
                                    ? orange
                                    : Theme.of(context).canvasColor,
                                fontSize: topicindex == index ? 14 : 15.5),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) => SizedBox(
                      width: 10,
                    ),
                itemCount: topic.length),
          ),
        ),
        const Gap(15),
        Flexible(flex: 18, child: PostsWidget()),
      ]),
    );
  }

  Widget PostsWidget() {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collectionGroup('Texts').snapshots();
    var rng = Random();
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
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 70),
            child: StaggeredGrid.count(
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                if (data['Topic'] == topic[topicindex]) {
                  print(topic);
                  return DiscoverWidget(
                    data: data,
                    count: rng.nextInt(3) + 1,
                  );
                } else if (topic[topicindex] == "All") {
                  return DiscoverWidget(
                    data: data,
                    count: rng.nextInt(3) + 1,
                  );
                } else {
                  return Center();
                }
              }).toList(),
            ),
          ),
        );
      },
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
    print(topic);
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
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 70),
            child: StaggeredGrid.count(
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                if (data['Topic'] == topic) {
                  print(topic);
                  return DiscoverWidget(
                    data: data,
                    count: rng.nextInt(3) + 1,
                  );
                } else if (topic == "All") {
                  return DiscoverWidget(
                    data: data,
                    count: rng.nextInt(3) + 1,
                  );
                } else {
                  return Center(
                    child: Text("data"),
                  );
                }
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
