import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Screen/MessageScreen/MessageList.dart';
import 'package:flutter_application_1/Screen/UserProfileScreen/builUserProfile.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'MessagesWidget.dart';

enum Menu {
  delete,
}

class Messages extends StatefulWidget {
  String useruid;

  String groupid;

  Messages({required this.useruid, required this.groupid});

  @override
  State<Messages> createState() =>
      _MessagesState(useruid: useruid, groupid: groupid);
}

class _MessagesState extends State<Messages> {
  String useruid;

  String groupid;
  TextEditingController _textcontrol = TextEditingController();
  _MessagesState({required this.useruid, required this.groupid});
  String? _selectedMenu;
  bool daycontrol = false;
  String dayval = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);

        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: buildAppBarForMessage(useruid)),
        /* actions: [
            PopupMenuButton<Menu>(
                color: Theme.of(context).canvasColor,
                // Callback that sets the selected popup menu item.
                onSelected: (Menu item) {
                  setState(() {
                    _selectedMenu = item.name;
                    print(item.index);
                    if (item.index == 0) {
                      //DeleteText();
                    }
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                      const PopupMenuItem<Menu>(
                        value: Menu.delete,
                        child: Text(
                          'Delete',
                          // style: TextStyle(color:Theme.),
                          /* style: GoogleFonts.dosis(
                          color: Theme.of(context).canvasColor, fontSize: 18),*/
                        ),
                      ),
                    ])
          ],*/

        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Messages")
                  .doc(groupid)
                  .collection(groupid)
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              if (dayval == snapshot.data!.docs[index]["day"]) {
                                daycontrol = false;
                                return Column(
                                  children: [
                                    MessageBubble(
                                      // daycontrol=true,

                                      index: index,
                                      message: snapshot.data!.docs[index],
                                      onPress: () {},
                                      listLength: 5,
                                    )
                                  ],
                                );
                              } else if (dayval !=
                                      snapshot.data!.docs[index]["day"] ||
                                  index == 0) {
                                dayval = snapshot.data!.docs[index]["day"];

                                return Column(
                                  children: [
                                    Center(
                                      child: Material(
                                        elevation: 1,
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 6),
                                          child: Text(
                                              snapshot.data!.docs[index]["day"],
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: Theme.of(context)
                                                      .cardColor)),
                                        ),
                                      ),
                                    ),
                                    MessageBubble(
                                      // daycontrol=false,

                                      index: index,
                                      message: snapshot.data!.docs[index],
                                      onPress: () {},
                                      listLength: 5,
                                    )
                                  ],
                                );
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.grey.shade100),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: _textcontrol,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xff9C9EB9)),
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 0.0),
                                              hintText: 'Message...',
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
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                sendText(_textcontrol.text);
                                _textcontrol.clear();
                              },
                              child: const CircleAvatar(
                                backgroundColor: orange,
                                radius: 20,
                                child: Icon(
                                  Icons.send,
                                  size: 19,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text("No message in here"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.grey.shade100),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xff9C9EB9)),
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 0.0),
                                              hintText: 'Message...',
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
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                sendText(_textcontrol.text);
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  Icons.send,
                                  size: 19,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }

  /*Future<void> DeleteText() async {
    print(groupid);
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(groupid.toString())
        .delete()
        .then((value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Messages(
                useruid: useruid,
                groupid: groupid,
                name: this.name,
              ),
            )));
  }*/

  Future<void> sendText(String text) async {
    FirebaseFirestore.instance
        .collection('Messages')
        .doc(groupid)
        .collection(groupid)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      "from": FirebaseAuth.instance.currentUser!.uid,
      "to": useruid,
      "content": text,
      "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      "day": DateFormat('EEEE, M/d/y').format(DateTime.now()),
      "time": DateFormat('Hm').format(DateTime.now()),
    });
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Message")
        .doc(groupid)
        .update(
            {"recent": text, "from": FirebaseAuth.instance.currentUser!.uid});
    FirebaseFirestore.instance
        .collection('Users')
        .doc(useruid)
        .collection("Message")
        .doc(groupid)
        .update(
            {"recent": text, "from": FirebaseAuth.instance.currentUser!.uid});
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.message,
    required this.onPress,
    required this.index,
    required this.listLength,
  });

  final QueryDocumentSnapshot message;
  final VoidCallback onPress;
  int index;
  int listLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Column(
        crossAxisAlignment:
            message['from'] == FirebaseAuth.instance.currentUser!.uid
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: message['from'] == FirebaseAuth.instance.currentUser!.uid
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: onPress,
              child: Container(
                margin:
                    message['from'] == FirebaseAuth.instance.currentUser!.uid
                        ? EdgeInsets.only(left: 100)
                        : EdgeInsets.only(right: 100),
                child: Material(
                  elevation: 1,
                  color:
                      message['from'] == FirebaseAuth.instance.currentUser!.uid
                          ? Colors.teal
                          : Colors.grey.withOpacity(0.5),
                  borderRadius:
                      message['from'] != FirebaseAuth.instance.currentUser!.uid
                          ? BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))
                          : BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(0)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text(
                      message['content'],
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
            child: Text(
              message["time"].toString().split(" ").first,
              maxLines: 1,
              style:
                  TextStyle(color: Theme.of(context).canvasColor, fontSize: 10),
            ),
          ),

          SizedBox(
            height: 4,
          ),
          // Text(time.toString())
        ],
      ),
    );
  }
}
