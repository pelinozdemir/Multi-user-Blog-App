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

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int current = 0;
  void initState() {
    current = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                  0.0,
                  1.0
                ],
                    colors: [
                  Theme.of(context).primaryColor.withOpacity(0.2),
                  Theme.of(context).accentColor.withOpacity(0.5),
                ])),
            child: ListView(
              children: [
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
                ListTile(
                  leading: Icon(
                    Icons.screen_lock_landscape_rounded,
                    // size: _drawerIconSize,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Splash Screen',
                    style: TextStyle(
                        fontSize: 17, color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen(title: "Splash Screen")));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.login_rounded,
                      //  size: _drawerIconSize,
                      color: Theme.of(context).accentColor),
                  title: Text(
                    'Login Page',
                    style: TextStyle(
                        //  fontSize: _drawerFontSize,
                        color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    //     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
                  },
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.person_add_alt_1,
                      //  size: _drawerIconSize,
                      color: Theme.of(context).accentColor),
                  title: Text(
                    'Registration Page',
                    style: TextStyle(
                        //   fontSize: _drawerFontSize,
                        color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()),);
                  },
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  height: 1,
                ),
                ListTile(
                  leading: Icon(
                    Icons.password_rounded,
                    // size: _drawerIconSize,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Forgot Password Page',
                    style: TextStyle(
                        // fontSize: _drawerFontSize,
                        color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    //  Navigator.push( context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()),);
                  },
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  height: 1,
                ),
                ListTile(
                  leading: Icon(
                    Icons.verified_user_sharp,
                    //  size: _drawerIconSize,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Verification Page',
                    style: TextStyle(
                        //   fontSize: _drawerFontSize,
                        color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    //  Navigator.push( context, MaterialPageRoute(builder: (context) => ForgotPasswordVerificationPage()), );
                  },
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  height: 1,
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    //  size: _drawerIconSize,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                        //   fontSize: _drawerFontSize,
                        color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Container(
              //  color: Colors.red,
              margin: EdgeInsets.fromLTRB(30, 20, 25, 10),
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              height: 180,
              child: buildImage(),
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
                            account('FollowingNumber', 'Following'),
                            buildDivider(),
                            account('FollowersNumber', 'Followers'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      setText(),
                      SizedBox(
                        height: 10,
                      ),
                      builInfo(),
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

  Widget account(String docname, String fieldname) {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.uid.toString());
    final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid.toString())
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
                Text(
                  snapshot.data![docname].toString(),
                ),
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
    );
  }

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

  Widget setText() {
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
            //color: Colors.red,
            child: Column(children: [
              Text(
                snapshot.data!['Name'].toString(),
              ),
              Text(
                snapshot.data!['Biography'].toString(),
              ),
            ]),
          );
        } else {
          return Container();
        }
      },
    );
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
