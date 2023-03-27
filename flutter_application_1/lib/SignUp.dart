import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Screen/Home.dart';
import 'package:google_fonts/google_fonts.dart';
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
            "Biography": "",
            "About": ""
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
                .collection('TextInfo')
                .doc("Likes")
                .set({"textname": ""});
          }).then((value) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection('TextInfo')
                .doc("Save")
                .set({"textname": ""});
          }).then((value) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection('TextInfo')
                .doc("Share")
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
            .set({}).then((value) => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('HATA'),
                      content: Text('Kullanıcı oluşturuldu'),
                    )));
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
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
            child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: MediaQuery.of(context).size.width * 1.03,
                )),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.18,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text("Welcome to app",
                          style: GoogleFonts.dosis(
                            fontWeight: FontWeight.w400,
                            fontSize: 35,
                            color: Colors.black26,
                          )))),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: ClipOval(
                          child: image != null
                              ? Image.file(
                                  image!,
                                  width: 160,
                                  height: 160,
                                )
                              : Container(
                                  color: orange,
                                  padding: EdgeInsets.all(15),
                                  child: Icon(
                                    Icons.camera_alt,
                                    //color: Colors.lightBlue,
                                    size: 60,
                                  ),
                                ),
                        ),
                        hoverColor: Colors.black,
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
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.shade100),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: name,
                                  style: GoogleFonts.dosis(
                                      fontSize: 16, color: Color(0xff9C9EB9)),
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 0.0),
                                    hintText: 'Username',
                                    hintStyle: TextStyle(
                                      color: Color(0xff8E8E93),
                                    ),
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.shade100),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: mail,
                                  style: GoogleFonts.dosis(
                                      fontSize: 16, color: Color(0xff9C9EB9)),
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 0.0),
                                    hintText: 'Mail',
                                    hintStyle: TextStyle(
                                      color: Color(0xff8E8E93),
                                    ),
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.shade100),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: password,
                                  style: GoogleFonts.dosis(
                                      fontSize: 16, color: Color(0xff9C9EB9)),
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 0.0),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: Color(0xff8E8E93),
                                    ),
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: orange,
                                padding: EdgeInsets.all(8)),
                            onPressed: (() async {
                              signUp();
                            }),
                            child: Text('Signup',
                                style: GoogleFonts.dosis(
                                    fontSize: 25, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        )),
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

/*


 */