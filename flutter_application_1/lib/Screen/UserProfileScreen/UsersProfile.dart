import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Colors/Theme.dart';
import 'package:flutter_application_1/Screen/HomeScreen/blogPage.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/AboutUser.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/ProfileUpdate.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/ProfileBlogText.dart';

import 'package:flutter_application_1/Screen/UserProfileScreen/builUserProfile.dart';

import 'package:flutter_application_1/Tags/BlogTopic.dart';

import 'package:flutter_application_1/Tags/TopicTags.dart';
import 'package:flutter_application_1/models/changetheme.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:provider/provider.dart';
import 'package:stylish_bottom_bar/helpers/enums.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/model/options.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:theme_button/theme_button.dart';

import '../../Widgets/userswidget.dart';
import '../AddScreen/AddNew.dart';
import '../DiscvoverScreen/DiscoverPage.dart';
import '../MessageScreen/Messages.dart';
import '../ProfileScreen/Profile.dart';
import 'UserBlogText.dart';
import 'UsersAboutPage.dart';

class UsersProfile extends StatefulWidget {
  String name;
  String uid;
  bool following;
  UsersProfile(
      {required this.name, required this.uid, required this.following});
  @override
  State<UsersProfile> createState() =>
      _UsersProfileState(name: name, uid: uid, following: following);
}

class _UsersProfileState extends State<UsersProfile> {
  int current = 0;
  String useruid = "";
  String name;
  String uid;
  bool following;
  _UsersProfileState(
      {required this.name, required this.uid, required this.following});

  void initState() {
    current = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _value = Provider.of<ColorThemeData>(context).isLight;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);

        return false;
      },
      child: Scaffold(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),

          //   iconTheme: IconThemeData(color: Colors.white),

          leading: BackButton(
            color: Theme.of(context).canvasColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 30, top: 15, bottom: 10),
              decoration: BoxDecoration(
                  //  color: Theme.of(context).canvasColor.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: ThemeButton(
                width: 40,
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
                    child: buildImageCircle(uid.toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                    child: setText(uid),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 0, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        account('FollowersNumber', 'Followers', uid),
                        buildDivider(),
                        account('FollowingNumber', 'Following', uid),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.red,
              margin: EdgeInsets.fromLTRB(25, 155, 10, 10),
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              height: MediaQuery.of(context).size.height * 0.075,
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  builInfo(),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.101,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: orange,
                      ),
                      child: IconButton(
                          padding: EdgeInsets.all(2),
                          onPressed: () {
                            createmessage();
                          },
                          icon: Center(
                            child: Icon(
                              Icons.send,
                              size: 20,
                            ),
                          )))
                ],
              ),
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
                SingleChildScrollView(
                    child: UserBlogText(uid: uid, name: name)),
                UserAboutPage(
                  uid: uid,
                  name: name,
                ),
              ], context),
            ),
          ],
        )),

        //body: Stack(alignment: Alignment.center, children: [BuildProfile()])
      ),
    );
  }

  Widget builInfo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: EdgeInsets.only(left: 5, right: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                side: BorderSide(
                    color: following
                        ? orange
                        : Theme.of(context).scaffoldBackgroundColor,
                    width: 1)),
            elevation: 10,
            backgroundColor:
                following ? Theme.of(context).scaffoldBackgroundColor : orange),
        onPressed: () async {
          setState(() {
            if (following) {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                  .collection('Account')
                  .doc('Following')
                  .update({uid.toString(): FieldValue.delete()});
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                  .collection('Account')
                  .doc('followNumbers')
                  .update({'FollowingNumber': FieldValue.increment(-1)});
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uid.toString())
                  .collection('Account')
                  .doc('Followers')
                  .update({uid.toString(): FieldValue.delete()});
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uid.toString())
                  .collection('Account')
                  .doc('followNumbers')
                  .update({'FollowersNumber': FieldValue.increment(-1)});

              following = false;
            } else {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                  .collection('Account')
                  .doc('Following')
                  .update({uid.toString(): name});
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                  .collection('Account')
                  .doc('followNumbers')
                  .update({'FollowingNumber': FieldValue.increment(1)});
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uid.toString())
                  .collection('Account')
                  .doc('Followers')
                  .update({uid.toString(): name});
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uid.toString())
                  .collection('Account')
                  .doc('followNumbers')
                  .update({'FollowersNumber': FieldValue.increment(1)});
              following = true;
            }
          });
        },
        child: Text(
          following ? 'Following' : 'Follow',
          style: GoogleFonts.dosis(
              color: following ? orange : Theme.of(context).canvasColor,
              fontWeight: FontWeight.w400,
              fontSize: 18),
        ),
      ),
    );
  }

  Future<void> createmessage() async {
    bool controlgroup = false;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Message")
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        if (element.id.contains(FirebaseAuth.instance.currentUser!.uid)) {
          element.data().forEach((key, val) async {
            if (key.contains("groupid")) {
              controlgroup = true;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Messages(
                      groupid: val,
                      useruid: uid,
                    ),
                  ));
            }
          });
        }
      });
    }).then((value) async {
      print(controlgroup);
      if (controlgroup == false) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Message")
            .doc(FirebaseAuth.instance.currentUser!.uid.toString() + uid)
            .set({
          "groupid": FirebaseAuth.instance.currentUser!.uid.toString() + uid,
          "with": uid,
          "recent": "",
          "from": FirebaseAuth.instance.currentUser!.uid
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(uid)
              .collection("Message")
              .doc(FirebaseAuth.instance.currentUser!.uid.toString() + uid)
              .set({
            "groupid": FirebaseAuth.instance.currentUser!.uid.toString() + uid,
            "with": FirebaseAuth.instance.currentUser!.uid.toString(),
            "recent": "",
            "from": FirebaseAuth.instance.currentUser!.uid
          }).then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Messages(
                    groupid:
                        FirebaseAuth.instance.currentUser!.uid.toString() + uid,
                    useruid: uid,
                  ),
                ));
          });
        });
      }
    });
  }
}
