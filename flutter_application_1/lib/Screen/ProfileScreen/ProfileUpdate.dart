import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Screen/Home.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/Profile.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/buildProfile.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileUpdate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileUpdate();
}

class _ProfileUpdate extends State<ProfileUpdate> {
  TextEditingController biography = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController about = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .snapshots();
    print(_usersStream);

    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            toolbarHeight: 60,
            title: Text(
              'Profili Düzenle',
              style: GoogleFonts.dosis(
                  color: Theme.of(context).canvasColor, fontSize: 20),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () async {
                  try {
                    if (biography.text.toString().isNotEmpty &&
                        name.text.toString().isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(
                              FirebaseAuth.instance.currentUser!.uid.toString())
                          .update({
                        "Name": name.text.toString(),
                        "Biography": biography.text.toString(),
                      }).then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(searching_name: ""),
                              )));
                    } else if (biography.text.toString().isEmpty &&
                        name.text.toString().isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(
                              FirebaseAuth.instance.currentUser!.uid.toString())
                          .update({
                        "Name": name.text.toString(),
                      }).then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(
                                  searching_name: "",
                                ),
                              )));
                    } else if (biography.text.toString().isNotEmpty &&
                        name.text.toString().isEmpty) {
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(
                              FirebaseAuth.instance.currentUser!.uid.toString())
                          .update({
                        "Biography": biography.text.toString(),
                      }).then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(
                                  searching_name: "",
                                ),
                              )));
                    }
                    saveAbout(about.text.toString());
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ]),
        body: StreamBuilder<DocumentSnapshot>(
          stream: _usersStream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // get course document

              // build list using names from sections
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  buildImage(),
                  SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: name,
                    // obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_right, color: arrow_color),
                        hintText: "Name",
                        hintStyle: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).canvasColor)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: biography,
                    // obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_right, color: arrow_color),
                        hintText: "Biography",
                        hintStyle: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).canvasColor)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).canvasColor),
                      //  focusNode: _focusNode,
                      controller: about,

                      autocorrect: true,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,

                      decoration: InputDecoration(
                          icon: Icon(Icons.arrow_right, color: arrow_color),
                          hintText: "About you",
                          hintStyle: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).canvasColor)),
                      onChanged: (val) {},
                      onTap: () {
                        if (snapshot.data!['About'].toString() != null) {
                          about.text = snapshot.data!['About'].toString();
                          //  print(_controller.text);
                        } else {}
                      },
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          },
        ));
  }

  Future<void> saveAbout(String? _controller) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "About": _controller.toString(),
      }).then((value) => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text(
                    'Kaydedildi',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ).then((value) => Navigator.pop(context)));
    } catch (e) {
      print(e);
    }
  }
}
