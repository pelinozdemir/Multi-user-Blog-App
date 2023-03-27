import 'package:awesome_bookmark_icon_button/awesome_bookmark_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/UserProfileScreen/builUserProfile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:transparent_image/transparent_image.dart';

import '../TextPage/TextPage.dart';

class FlowWidget extends StatefulWidget {
  String? id;
  FlowWidget({required this.id});

  @override
  State<FlowWidget> createState() => _FlowWidgetState(id: id);
}

class _FlowWidgetState extends State<FlowWidget> {
  String? id;
  _FlowWidgetState({required this.id});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _userstream = FirebaseFirestore.instance
        .collection('Posts')
        .doc(id)
        .collection('Texts')
        .snapshots();
    bool checkSave = false;
    bool checkLike = false;
    bool checkShare = false;
    int like = 0;
    return _userstream == null
        ? Text("data")
        : StreamBuilder<QuerySnapshot>(
            stream: _userstream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center();
              }
              return SingleChildScrollView(
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

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .doc(
                              FirebaseAuth.instance.currentUser!.uid.toString())
                          .collection("TextInfo")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        snapshot.data!.docs.forEach((element) {
                          Map<String, dynamic> datas =
                              element.data()! as Map<String, dynamic>;

                          if (element.id == 'Save' &&
                              datas.containsKey(data['Title'])) {
                            checkSave = true;
                          } else if (element.id == 'Save' &&
                              !datas.containsKey(data['Title'])) {
                            checkSave = false;
                          }
                          if (element.id == 'Likes' &&
                              datas.containsKey(data['Title'])) {
                            checkLike = true;
                          } else if (element.id == 'Likes' &&
                              !datas.containsKey(data['Title'])) {
                            checkLike = false;
                          }
                        });

                        return FlowWidgetDetails(
                            data, checkLike, checkSave, like);
                      },
                    );
                  }).toList(),
                ),
              );
            },
          );
  }

  Widget FlowWidgetDetails(
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
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        decoration: new BoxDecoration(
          //color: Colors.amber,
          //color: whitecoffee.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 200,
        child: Stack(
          fit: StackFit.loose,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                    color: Theme.of(context).scaffoldBackgroundColor,
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
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Theme.of(context).scaffoldBackgroundColor,
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
              top: 10,
              right: 0,
              child:
                  BuildImageUser(uid: data['user'], username: data['Author']),
            ),
            Positioned(
              top: 2,
              right: 48,
              child: BookMarkIconButton(
                iconSize: 27,
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
              top: 12,
              right: 80,
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
                size: 27,
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
