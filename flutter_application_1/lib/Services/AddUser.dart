import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/Error.dart';

class AddUser {
  String url = '';
  Future<void> signUp(TextEditingController name, TextEditingController mail,
      TextEditingController password, File? imagetemp) async {
    print('SGGGGGGGGG');
    try {
      upload(imagetemp!).then((value) async {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: mail.text, password: password.text)
            .then((user) {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            "Username": name.text,
            "UserMail": mail.text,
            "Password": password.text,
            "Profile": url,
          });
        });
      }).then((value) {
        FirebaseFirestore.instance.collection("UserID").doc('ID').update({
          "${FirebaseAuth.instance.currentUser!.uid}":
              "${FirebaseAuth.instance.currentUser!.uid}"
        });
      });
    } catch (e) {
      UserError();
    }
  }

  Future upload(File img) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profiles')
          .child(auth.currentUser!.uid)
          .child('userprofile');
      UploadTask uploadTask = ref.putFile(img);
      url = await (await uploadTask).ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
  }
}
