import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Colors/Theme.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/AboutUser.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/ProfileUpdate.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/ProfileBlogText.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/buildProfile.dart';
import 'package:flutter_application_1/Tags/BlogTopic.dart';

import 'package:flutter_application_1/Tags/TopicTags.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/retry.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

import '../../Widgets/userswidget.dart';

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
          title: Text("Profile Page",
              style: GoogleFonts.dosis(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Theme.of(context).canvasColor)),
          elevation: 0,
          iconTheme: Theme.of(context).iconTheme,
          flexibleSpace: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: IconButton(
                icon: Icon(
                  Icons.logout_rounded,
                  //  size: _drawerIconSize,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () => SystemNavigator.pop(),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.login_rounded,
                      //  size: _drawerIconSize,
                      color: Theme.of(context).iconTheme.color),
                  title: Text(
                    'Login Page',
                    style: TextStyle(
                        //  fontSize: _drawerFontSize,
                        color: Theme.of(context).canvasColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                    Navigator.pop(context);
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
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                        //   fontSize: _drawerFontSize,
                        color: Theme.of(context).canvasColor),
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
          fit: StackFit.loose,
          children: [
            Container(
              //color: Colors.red,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              // height: 180,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    //  color: Colors.red,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //  height: 180,
                    child: buildImage(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                    child: setText(FirebaseAuth.instance.currentUser!.uid),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 0, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        account('FollowersNumber', 'Followers',
                            FirebaseAuth.instance.currentUser!.uid),
                        buildDivider(),
                        account('FollowingNumber', 'Following',
                            FirebaseAuth.instance.currentUser!.uid),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.red,
              margin: EdgeInsets.fromLTRB(25, 155, 25, 10),
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              height: MediaQuery.of(context).size.height * 0.075,
              width: double.infinity,
              child: builInfo(),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // color: Colors.red,
              margin: EdgeInsets.fromLTRB(10, 190, 10, 10),
              padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
              height: MediaQuery.of(context).size.height * 0.8,
              child: buildButton([
                ProfileBlogText(),
                AboutUser(),
              ], context),
            ),
          ],
        )));
  }

  Widget builInfo() {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                side: BorderSide(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1)),
            elevation: 10,
            backgroundColor: orange),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileUpdate(),
              ));
        },
        child: Text(
          'Düzenle',
          style: GoogleFonts.dosis(
              color: Theme.of(context).canvasColor, fontSize: 18),
        ),
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
