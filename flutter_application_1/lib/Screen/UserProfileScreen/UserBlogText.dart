import 'package:awesome_bookmark_icon_button/awesome_bookmark_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

import '../../TextPage/TextPage.dart';

enum Menu { delete, edit }

class UserBlogText extends StatefulWidget {
  String uid;
  String? name;
  UserBlogText({required this.uid, this.name});
  @override
  State<StatefulWidget> createState() => _UserBlogText(uid: uid, name: name);
}

class _UserBlogText extends State<UserBlogText> {
  String uid;
  String? name;
  _UserBlogText({required this.uid, this.name});
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Posts')
        .doc(uid.toString())
        .collection('Texts')
        .snapshots();
    print(_usersStream);

    return _usersStream == null
        ? Text("data")
        : StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 40),
                  scrollDirection: Axis.vertical,
                  child: StaggeredGrid.count(
                    crossAxisSpacing: 20,
                    crossAxisCount: 1,
                    mainAxisSpacing: 20,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return UserBlogPageWidget(data);
                    }).toList(),
                  ),
                ),
              );
            },
          );
  }

  Widget UserBlogPageWidget(Map<String, dynamic> data) {
    bool checkSave = false;
    bool checkLike = false;
    bool checkShare = false;
    int like = 0;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .collection("TextInfo")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        snapshot.data!.docs.forEach((element) {
          Map<String, dynamic> datas = element.data()! as Map<String, dynamic>;

          if (element.id == 'Save' && datas.containsKey(data['Title'])) {
            checkSave = true;
          } else if (element.id == 'Save' &&
              !datas.containsKey(data['Title'])) {
            checkSave = false;
          }
          if (element.id == 'Likes' && datas.containsKey(data['Title'])) {
            checkLike = true;
          } else if (element.id == 'Likes' &&
              !datas.containsKey(data['Title'])) {
            checkLike = false;
          }
        });

        return UserTextWidget(data, checkLike, checkSave, like);
      },
    );
  }

  Widget UserTextWidget(
      Map<String, dynamic> data, bool checkLike, bool checkSave, int like) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TextPage(
            data: data,
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        decoration: new BoxDecoration(
          //color: Colors.amber,
          //color: whitecoffee.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        height: 220,
        child: Stack(
          fit: StackFit.loose,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                imageUrl: data['Image']!,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    new CircularProgressIndicator(value: 5.0),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                    color: Theme.of(context).backgroundColor.withOpacity(0.65),
                    child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 10.0),
                        text: TextSpan(
                          text: data['Title'].toString()[0].toUpperCase() +
                              data['Title']
                                  .toString()
                                  .substring(1)
                                  .toLowerCase(),
                          style: GoogleFonts.dosis(
                              color: Theme.of(context).canvasColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        )

                        //style: TextStyle(fontSize: 50),
                        ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color:
                          Theme.of(context).backgroundColor.withOpacity(0.65),
                    ),
                    width: double.infinity,
                    child: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                          text: data['Text'].toString(),
                          style: GoogleFonts.dosis(
                              color: Theme.of(context).cardColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )),
                  ),
                ]),
            Positioned(
              top: 10,
              left: 20,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                          text: data['Date'].toString(),
                          style: GoogleFonts.dosis(
                              color: Theme.of(context).canvasColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                          text: data['Topic'].toString(),
                          style: GoogleFonts.dosis(
                              color: Theme.of(context).canvasColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        )),
                  ]),
            ),
            Positioned(
              top: 0,
              right: 3,
              child: BookMarkIconButton(
                iconSize: 25,
                isSaved: checkSave ? true : false,
                onPressed: () {
                  setState(() {
                    if (checkSave == true) {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(
                              FirebaseAuth.instance.currentUser!.uid.toString())
                          .collection("TextInfo")
                          .doc("Save")
                          .update(
                              {data['Title'].toString(): FieldValue.delete()});

                      if (data["save"] <= 0) {
                        FirebaseFirestore.instance
                            .collection("Posts")
                            .doc(data["user"])
                            .collection("Texts")
                            .doc(data['Title'])
                            .update({"save": 0});
                      } else if (data["save"] > 0) {
                        FirebaseFirestore.instance
                            .collection("Posts")
                            .doc(data["user"])
                            .collection("Texts")
                            .doc(data['Title'])
                            .update({"save": FieldValue.increment(-1)});
                      }

                      checkSave = false;
                    } else if (checkSave != true) {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(
                              FirebaseAuth.instance.currentUser!.uid.toString())
                          .collection("TextInfo")
                          .doc("Save")
                          .update({data['Title'].toString(): data['user']});
                      checkSave = true;

                      FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(data["user"])
                          .collection("Texts")
                          .doc(data['Title'])
                          .update({"save": FieldValue.increment(1)});
                    }
                  });
                },
                padding: EdgeInsets.only(left: 10),
              ),
            ),
            Positioned(
              top: 10,
              right: 40,
              child: LikeButton(
                animationDuration: const Duration(milliseconds: 1000),
                likeCountAnimationDuration: const Duration(milliseconds: 500),
                bubblesColor: const BubblesColor(
                  dotPrimaryColor: Color(0xFFFFC107),
                  dotSecondaryColor: Color(0xFFFF9800),
                  dotThirdColor: Color(0xFFFF5722),
                  dotLastColor: Color(0xFFF44336),
                ),
                circleColor: const CircleColor(
                    start: Color(0xFFFF5722), end: Color(0xFFFFC107)),
                size: 25,
                isLiked: checkLike ? true : false,
                // likeCountAnimationType: LikeCountAnimationType.none,
                // likeCountPadding: EdgeInsets.all(5),
                //likeCount: like,
                //countPostion: CountPostion,
                onTap: (isLiked) async {
                  setState(() {
                    if (checkLike) {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(
                              FirebaseAuth.instance.currentUser!.uid.toString())
                          .collection("TextInfo")
                          .doc("Likes")
                          .update(
                              {data['Title'].toString(): FieldValue.delete()});

                      if (data["like"] <= 0) {
                        FirebaseFirestore.instance
                            .collection("Posts")
                            .doc(data["user"])
                            .collection("Texts")
                            .doc(data['Title'])
                            .update({"like": 0});
                      } else if (data["like"] > 0) {
                        FirebaseFirestore.instance
                            .collection("Posts")
                            .doc(data["user"])
                            .collection("Texts")
                            .doc(data['Title'])
                            .update({"like": FieldValue.increment(-1)});

                        FirebaseFirestore.instance
                            .collection("Posts")
                            .doc(data["user"])
                            .collection("Texts")
                            .doc(data['Title'])
                            .snapshots()
                            .listen((event) {
                          event.data()!.forEach((key, value) {
                            if (key == "like") {
                              like = value;
                            }
                          });
                        });
                      }

                      checkLike = false;
                    } else if (checkLike != true) {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(
                              FirebaseAuth.instance.currentUser!.uid.toString())
                          .collection("TextInfo")
                          .doc("Likes")
                          .update({data['Title'].toString(): data['user']});
                      FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(data["user"])
                          .collection("Texts")
                          .doc(data['Title'])
                          .update({"like": FieldValue.increment(1)});
                      FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(data["user"])
                          .collection("Texts")
                          .doc(data['Title'])
                          .snapshots()
                          .listen((event) {
                        event.data()!.forEach((key, value) {
                          if (key == "like") {
                            like = value;
                          }
                        });
                      });

                      checkLike = true;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* */