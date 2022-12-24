import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: darkBlue,
          toolbarHeight: 100,
          title: Text('Profili Düzenle'),
          actions: [
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                      .update({
                    "Name": name.text.toString(),
                    "Biography": biography.text.toString(),
                  }).then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(),
                          ),
                          (route) => false));
                } catch (e) {
                  print(e);
                }
              },
            ),
          ]),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            buildImage(),
            SizedBox(
              height: 50,
            ),
            TextField(
              controller: name,
              // obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                labelText: 'Name',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: biography,
              // obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                labelText: 'Biography',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
