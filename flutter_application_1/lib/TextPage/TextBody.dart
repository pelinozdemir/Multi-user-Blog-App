import 'dart:ffi';
import 'package:like_button/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_bookmark_icon_button/awesome_bookmark_icon_button.dart';

class TextBody extends StatefulWidget {
  Map<String, dynamic> data;
  TextBody({required this.data});
  @override
  State<StatefulWidget> createState() => _TextBody(data: data);
}

class _TextBody extends State<TextBody> {
  Map<String, dynamic> data;
  _TextBody({required this.data});

  bool? checkSave;
  bool checkLike = false;
  bool checkShare = false;
  int like = 0;
  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

        return TextBodyWidget(
            data: data, checkLike: checkLike, checksave: checkSave, like: like);
      },
    );
  }
}

class TextBodyWidget extends StatefulWidget {
  Map<String, dynamic> data;
  bool? checksave;
  bool? checkLike;
  int like;

  TextBodyWidget(
      {required this.data,
      required this.checksave,
      required this.checkLike,
      required this.like});
  @override
  State<TextBodyWidget> createState() => _TextBodyWidgetState(
      data: data, checksave: checksave, checkLike: checkLike, like: like);
}

class _TextBodyWidgetState extends State<TextBodyWidget> {
  bool? checksave;
  bool? checkLike;
  int like = 0;
  Map<String, dynamic> data;
  _TextBodyWidgetState(
      {required this.data,
      required this.checkLike,
      required this.checksave,
      required this.like});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(right: 2, left: 10, top: 8, bottom: 8),
              child: BookMarkIconButton(
                iconSize: 35,
                isSaved: checksave! ? true : false,
                onPressed: () {
                  setState(() {
                    if (checksave == true) {
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

                      checksave = false;
                    } else if (checksave != true) {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(
                              FirebaseAuth.instance.currentUser!.uid.toString())
                          .collection("TextInfo")
                          .doc("Save")
                          .update({data['Title'].toString(): data['user']});
                      checksave = true;

                      FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(data["user"])
                          .collection("Texts")
                          .doc(data['Title'])
                          .update({"save": FieldValue.increment(1)});
                    }
                  });
                },
                padding: EdgeInsets.all(8),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 8, left: 10, top: 15, bottom: 8),
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
                size: 35,
                isLiked: checkLike! ? true : false,
                likeCountAnimationType: LikeCountAnimationType.all,
                likeCountPadding: EdgeInsets.all(5),
                likeCount: like,
                countPostion: CountPostion.right,
                onTap: (isLiked) async {
                  setState(() {
                    if (checkLike!) {
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
          //backgroundColor: Colors.white,
          expandedHeight: MediaQuery.of(context).size.height * 0.5,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(children: [
              Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.54,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(data['Image']),
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
                    ),
                  )),
              Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.height * 0.43,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                      ),
                      child: Column(children: [
                        RichText(
                          maxLines: 3,
                          strutStyle: StrutStyle(fontSize: 10.0),
                          text: TextSpan(
                            text: data['Title'],
                            style: GoogleFonts.anekBangla(
                                color: Theme.of(context).cardColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                textStyle: TextStyle(wordSpacing: 4.5)),
                          ),
                        ),
                      ]),
                    ),
                    width: double.maxFinite,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                          /* topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),*/
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
                    ),
                  )),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 0, right: 0),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              //  color: Colors.white,
              // borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: RichText(
                textAlign: TextAlign.justify,
                textWidthBasis: TextWidthBasis.parent,
                strutStyle: StrutStyle(fontSize: 20.0),
                text: TextSpan(
                  text: data['Text'],
                  style: GoogleFonts.merriweather(
                      color: Theme.of(context).canvasColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      textStyle: TextStyle(wordSpacing: 4.5)),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
