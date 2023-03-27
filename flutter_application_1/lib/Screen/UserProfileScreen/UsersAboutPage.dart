import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Screen/ProfileScreen/Profile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class UserAboutPage extends StatefulWidget {
  String uid;
  String? name;
  UserAboutPage({this.name, required this.uid});

  @override
  State<UserAboutPage> createState() =>
      _UserAboutPageState(name: name, uid: uid);
}

class _UserAboutPageState extends State<UserAboutPage> {
  String uid;
  String? name;
  _UserAboutPageState({this.name, required this.uid});
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid.toString())
        .snapshots();
    print(_usersStream);

    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Container(
              child: snapshot.data!['About'] == ""
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 200,
                              // color: Colors.amber,
                              child: Center(
                                child: Text(
                                  name.toString() +
                                      " hasn't added any information here yet",
                                  style: GoogleFonts.dosis(
                                      color: Theme.of(context).canvasColor),
                                ),
                              )),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  top: 20, left: 35, right: 35, bottom: 80),
                              height: 400,
                              // color: Colors.amber,
                              child: Text(
                                snapshot.data!['About'].toString(),
                                style: GoogleFonts.dosis(
                                    color: Theme.of(context).canvasColor),
                              )),
                        ],
                      ),
                    ));
        } else {
          return Container();
        }
      },
    );
  }
}

class AboutEditPage extends StatefulWidget {
  String? data;
  String? user_uid;

  AboutEditPage({
    this.data,
    this.user_uid,
  });

  @override
  State<AboutEditPage> createState() =>
      _AboutEditPageState(data: data, user_uid: user_uid);
}

class _AboutEditPageState extends State<AboutEditPage> {
  String? data;
  String? user_uid;
  _AboutEditPageState({this.data, this.user_uid});
  final TextEditingController _controller = new TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        title: Text(
          "About",
          style: TextStyle(color: Colors.black38),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 1.0,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                saveAbout(_controller.text.toString());
                // print(_controller.text);
              },
              icon: Icon(
                Icons.done,
                color: Colors.black38,
              ))
        ],
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 30, top: 20),
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                //  focusNode: _focusNode,
                controller: _controller,

                autocorrect: true,
                maxLines: null,
                keyboardType: TextInputType.multiline,

                decoration: InputDecoration(
                    icon: Icon(Icons.arrow_right, color: arrow_color),
                    hintText: "Kendinizden bahsedin.",
                    hintStyle: TextStyle(fontSize: 18, color: Colors.black)),
                onChanged: (val) {},
                onTap: () {
                  if (data.toString() != null) {
                    _controller.text = data.toString();
                    //  print(_controller.text);
                  } else {}
                },
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> saveAbout(String? _controller) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    print(_controller.toString());
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user_uid)
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
