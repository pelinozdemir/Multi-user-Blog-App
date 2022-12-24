import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Home.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File? image;
  File? imagetemp;
  int done = 0;
  TextEditingController mail = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String downloadurl = '';

  Future<void> signUp() async {
    try {
      upload(imagetemp!).then((value) async {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: mail.text, password: password.text)
            .then((user) {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(auth.currentUser!.uid)
              .set({
            "Username": name.text,
            "UserMail": mail.text,
            "Password": password.text,
            "Profile": downloadurl,
            "Name": "",
            "Biography": ""
          }).then((value) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection('Account')
                .doc("Followers")
                .set({
              "Username": "",
            });
          }).then((value) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection('Account')
                .doc("Following")
                .set({
              "Username": "",
            });
          }).then((value) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection('Account')
                .doc("followNumbers")
                .set({"FollowersNumber": 0, "FollowingNumber": 0});
          }).then((value) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection('Likes')
                .doc()
                .set({"textname": ""});
          }).then((value) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection('Save')
                .doc()
                .set({"textname": ""});
          }).then((value) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection('Share')
                .doc()
                .set({"textname": ""});
          });
        });
      }).then((value) {
        FirebaseFirestore.instance
            .collection("UserID")
            .doc('ID')
            .update({"${auth.currentUser!.uid}": "${auth.currentUser!.uid}"});
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('Posts')
            .doc(auth.currentUser!.uid)
            .set({});
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('HATA'),
                content: Text(
                    'Kullanıcı bulunamadı. Lütfen bilgileriniz doğruluğundan emin olun.'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 7, 201),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                InkWell(
                  child: ClipOval(
                    child: image != null
                        ? Image.file(
                            image!,
                            width: 160,
                            height: 160,
                          )
                        : Icon(
                            Icons.camera_alt,
                            size: 60,
                          ),
                  ),
                  hoverColor: Colors.white,
                  onTap: () {
                    setState(() {
                      showCupertinoModalPopup<ImageSource>(

                          //barrierColor: Colors.white,
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                                actions: [
                                  CupertinoActionSheetAction(
                                    child: Text(
                                      'Kamera',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    onPressed: () async =>
                                        pickImage(ImageSource.camera),
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text(
                                      'Galeri',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    onPressed: () async =>
                                        pickImage(ImageSource.gallery),
                                  ),
                                ],
                              ));
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: name,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: mail,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: password,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: (() async {
                await signUp();
              }),
              child: Text('KAYDOL', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      imagetemp = File(image.path);
      setState(() {
        this.image = imagetemp!;
      });
    } catch (e) {
      print(e);
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
      String url = await (await uploadTask).ref.getDownloadURL();
      if (mounted)
        setState(() {
          downloadurl = url;
        });
    } catch (e) {
      print(e);
    }
  }
}
