import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Colors/Theme.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/ProfileUpdate.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/UserBlogText.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/buildProfile.dart';
import 'package:flutter_application_1/Tags/BlogTopic.dart';
import 'package:flutter_application_1/Tags/ProfileTag.dart';
import 'package:flutter_application_1/Tags/TopicTags.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/retry.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

class UsersProfile extends StatefulWidget {
  String? name;
  UsersProfile({this.name});
  @override
  State<UsersProfile> createState() => _UsersProfileState(name: name);
}

class _UsersProfileState extends State<UsersProfile> {
  int current = 0;
  void initState() {
    current = 0;
    //setText();
    super.initState();
  }

  String? name;
  _UsersProfileState({this.name});
  var uid;
  @override
  Widget build(BuildContext context) {
    setText();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile Page",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor,
                ])),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(
                top: 16,
                right: 16,
              ),
              child: Stack(
                children: <Widget>[
                  Icon(Icons.notifications),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),

        /*DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).accentColor,
                      ],
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "FlutterTutorial.Net",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),*/

        body: SingleChildScrollView(
            child: Stack(
          children: [
            Container(
              //  color: Colors.red,
              margin: EdgeInsets.fromLTRB(30, 20, 25, 10),
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              height: 180,
              //child: buildImage(),
            ),
            Container(
              //color: Colors.red,
              margin: EdgeInsets.fromLTRB(180, 20, 25, 10),
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              height: 180,
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: Row(
                          children: [
                            //  account('FollowingNumber', 'Following'),
                            buildDivider(),
                            //  account('FollowersNumber', 'Followers'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      createSetText(),
                      //  setText(),
                      SizedBox(
                        height: 10,
                      ),
                      // builInfo(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              //color: Colors.red,
              margin: EdgeInsets.fromLTRB(5, 220, 5, 10),
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              height: 530,
              child: buildButton(),
            ),
          ],
        ))

        /*Column(
        children: [
          /* Stack(
            children: [
              Positioned(
                child: buildImage(),
                top: 20,
                left: 10,
              ),
              Positioned(
                child: setText(),
                top: 20,
                left: 100,
              )
            ],
          ),*/
          Flexible(
            flex: 15,
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  buildImage(),
                  const SizedBox(
                    height: 20,
                  ),
                  setText(),
                  Center(child: builInfo()),
                  Gap(20),
                ]),
          ),
          Flexible(flex: 30, child: buildButton()),
        ],
      ),*/

        //body: Stack(alignment: Alignment.center, children: [BuildProfile()])
        );
  }

  /* Widget account(String docname, String fieldname) {
    FirebaseFirestore.instance
        .collection('userNames')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.id);
      });
    });
    return Container();
    //print(uid.toString());
    /* final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid.toString())
        .collection('Account')
        .doc('followNumbers')
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return MaterialButton(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /* Text(
                 // snapshot.data![docname].toString(),
                ),*/
                SizedBox(
                  height: 4,
                ),
                Text(fieldname),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );*/
  }*/

  Widget buildButton() {
    return Container(
      child: ContainedTabBarView(
        tabs: [
          Text(
            'About',
            style: TextStyle(color: Colors.black),
          ),
          Text(
            'All',
            style: TextStyle(color: Colors.black),
          ),
          Text(
            'Blog',
            style: TextStyle(color: Colors.black),
          ),
          Text(
            'Lists',
            style: TextStyle(color: Colors.black),
          ),
        ],
        views: [
          Container(

              // AboutPage();
              ),
          SingleChildScrollView(
              // child:  AllPage(),
              ),
          UserBlogText(),
          Container(
              //  color: Colors.red,
              )
        ],
        onChange: (index) => print(index),
      ),
    );
    /*  return ContainedTabBarView(
      tabs: [
        Text(''),
      ],
      views: [
        Container(
          color: Colors.red,
        )
      ],
    );*/
  }

  Widget builInfo() {
    setText();
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(shape: StadiumBorder(), elevation: 10),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileUpdate(),
              ));
        },
        child: Text('Düzenle', style: TextStyle(fontSize: 15)),
      ),
    );
  }

  Future<String> setText() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .where("Username", isEqualTo: name)
        .limit(1)
        .get()
        .then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((item) {
              //print("item");
              uid = item.reference.id;
              // print(item.reference.id);
            }),
          },
        )
        .then((value) => print(uid))
        .then((value) {
      print("HELLOOOO");

      var _usersStream = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid.toString())
          .get();
      //print(_usersStream.then((value) => print(value.data().toString())));

      return uid.toString();
    });
    print("PELİNNNN");
    print(uid);
    return uid.toString();
  }

  buildDivider() {
    return Container(
      height: 25,
      child: VerticalDivider(
        width: 10,
        thickness: 1,
        color: Colors.black,
      ),
    );
  }

  Widget createSetText() {
    print(uid);
    final Stream<DocumentSnapshot> _usersStream =
        FirebaseFirestore.instance.collection('Users').doc(uid).snapshots();
    print(_usersStream);
    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // get course document
          print(
            snapshot.data!['Name'].toString(),
          );
          // build list using names from sections
          return Container(
              //color: Colors.red,
              /*  child: Column(children: [
              Text(
                snapshot.data!['Name'].toString(),
              ),
              Text(
                snapshot.data!['Biography'].toString(),
              ),
            ]),*/
              );
        } else {
          return Container();
        }
      },
    );
  }
}

buildAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(100.0),
    child: Padding(
      padding: EdgeInsets.only(top: 50),
      child: Row(
        children: [IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back))],
      ),
    ),
  );
}
