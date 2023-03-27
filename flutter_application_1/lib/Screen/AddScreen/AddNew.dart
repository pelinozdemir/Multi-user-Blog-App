import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Tags/BlogTopic.dart';
import 'package:image_picker/image_picker.dart';

class AddNew extends StatefulWidget {
  @override
  State<AddNew> createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  File? image;
  File? imagetemp;
  String? desc, text;
  String title = '';
  String? downloadurl = '';
  int index = 0;
  String date = DateFormat().format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  saveButton();
                },
                icon: Icon(Icons.done)),
            bottom: PreferredSize(
                child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  width: 100,
                  child: Center(
                    child: Text(
                      '${title}',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                preferredSize: Size.fromHeight(20)),
            expandedHeight: 350.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              /* title: Text("${title}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),*/
              background: GestureDetector(
                child: Container(
                  //color: Colors.white,
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.add_a_photo,
                          size: 40,
                        ),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
                onTap: () {
                  setState(() {
                    showCupertinoModalPopup<ImageSource>(
                        context: context,
                        builder: ((context) => CupertinoActionSheet(
                              actions: [
                                CupertinoActionSheetAction(
                                  child: Text(
                                    'Kamera',
                                    style: GoogleFonts.dosis(
                                        color: Theme.of(context).canvasColor,
                                        fontSize: 20),
                                  ),
                                  onPressed: () async =>
                                      pickImage(ImageSource.camera),
                                ),
                                CupertinoActionSheetAction(
                                  child: Text(
                                    'Galeri',
                                    style: GoogleFonts.dosis(
                                        color: Theme.of(context).canvasColor,
                                        fontSize: 20),
                                  ),
                                  onPressed: () async =>
                                      pickImage(ImageSource.gallery),
                                ),
                              ],
                            )));
                  });
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: TextField(
                    style: GoogleFonts.dosis(
                        color: Theme.of(context).canvasColor, fontSize: 15),
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_right, color: arrow_color),
                        hintText: "Title",
                        hintStyle: GoogleFonts.dosis(
                            fontSize: 15,
                            color: Theme.of(context).canvasColor)),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: TextField(
                    autocorrect: true,
                    style: GoogleFonts.dosis(
                        color: Theme.of(context).canvasColor, fontSize: 15),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_right, color: arrow_color),
                        hintText: "Description",
                        hintStyle: GoogleFonts.dosis(
                            fontSize: 15,
                            color: Theme.of(context).canvasColor)),
                    onChanged: (val) {
                      desc = val;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: TextField(
                    autocorrect: true,
                    style: GoogleFonts.dosis(
                        color: Theme.of(context).canvasColor, fontSize: 15),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_right, color: arrow_color),
                        hintText: "Write yout idea",
                        hintStyle: GoogleFonts.dosis(
                            fontSize: 15,
                            color: Theme.of(context).canvasColor)),
                    onChanged: (val) {
                      text = val;
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void saveButton() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: topic
            .map((e) => CupertinoActionSheetAction(
                onPressed: () async {
                  FirebaseAuth auth = FirebaseAuth.instance;

                  try {
                    Reference ref = FirebaseStorage.instance
                        .ref()
                        .child('writing')
                        .child('${title}');

                    await uploadImage(ref).then((value) async {
                      var docsnap = await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(auth.currentUser!.uid.toString())
                          .get();

                      Map<String, dynamic> data = docsnap.data()!;

                      await FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(auth.currentUser!.uid)
                          .collection("Texts")
                          .doc(title)
                          .set({
                        "user":
                            FirebaseAuth.instance.currentUser!.uid.toString(),
                        "like": 0.toInt(),
                        "save": 0.toInt(),
                        "Author": data['Username'],
                        "Title": title,
                        "Desc": desc,
                        "Text": text,
                        "Topic": e.toString().trim(),
                        "Image": downloadurl.toString().trim(),
                        "Date": date
                      });
                    }).then((value) => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(
                              'Kaydedildi',
                              style: GoogleFonts.dosis(fontSize: 15),
                            ),
                          ),
                        ));
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(e)))
            .toList(),
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

  Future uploadImage(Reference ref) async {
    if (imagetemp != null) {
      UploadTask uploadTask = ref.putFile(imagetemp!);
      String url = await (await uploadTask).ref.getDownloadURL();
      setState(() {
        downloadurl = url;
      });
    }
  }
}
