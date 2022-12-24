import 'dart:io';
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
  String? author, desc, text;
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
            backgroundColor: darkBlue,
            expandedHeight: 500.0,
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
                  color: Colors.white,
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
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: TextField(
                    autocorrect: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_right, color: arrow_color),
                        hintText: "Yazar Adı",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        )),
                    onChanged: (val) {
                      author = val;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_right, color: arrow_color),
                        hintText: "Başlık",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        )),
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
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_right, color: arrow_color),
                        hintText: "Düşüncelerinizi paylaşın",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        )),
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
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        icon: Icon(Icons.arrow_right, color: arrow_color),
                        hintText: "Düşüncelerinizi paylaşın",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        )),
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
      floatingActionButton: Container(
        color: Color.fromARGB(0, 250, 247, 247),
        width: 100,
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(226, 213, 143, 143),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () async {
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
                              await FirebaseFirestore.instance
                                  .collection("Posts")
                                  .doc(auth.currentUser!.uid)
                                  .collection("Texts")
                                  .doc(title)
                                  .set({
                                "Author": author,
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
                                    content: Text('Kaydedildi'),
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
          },
          child: Text('KAYDET'),
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
