import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../TextPage/TextPage.dart';

enum Menu { delete, edit }

class ProfileBlogText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileBlogText();
}

class _ProfileBlogText extends State<ProfileBlogText> {
  // User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Posts')
        .doc(user!.uid.toString())
        .collection('Texts')
        .snapshots();
    print(_usersStream);

    return _usersStream == null
        ? Text("data")
        : StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 180),
                  scrollDirection: Axis.vertical,
                  child: StaggeredGrid.count(
                    crossAxisSpacing: 20,
                    crossAxisCount: 1,
                    mainAxisSpacing: 20,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return UserTextWidget(data);
                    }).toList(),
                  ),
                ),
              );
            },
          );
  }

  Widget UserTextWidget(Map<String, dynamic> data) {
    String? _selectedMenu;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TextPage(
            data: data,
          ),
        ));
      },
      child: Container(
        //margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        decoration: new BoxDecoration(
          //color: Colors.amber,
          //color: whitecoffee.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        /*decoration: new BoxDecoration(color: whitecoffee,
         gradient: new LinearGradient(
              colors: [babypink, whitecoffee],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),*/
        height: 220,
        child: Stack(
          fit: StackFit.loose,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
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
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                  color: Theme.of(context).backgroundColor.withOpacity(0.65),
                  child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle(fontSize: 10.0),
                      text: TextSpan(
                        text: data['Title'].toString()[0].toUpperCase() +
                            data['Title'].toString().substring(1).toLowerCase(),
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
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Theme.of(context).backgroundColor.withOpacity(0.65),
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
              ],
            ),
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
            Container(
              // color: Colors.red,
              margin: EdgeInsets.fromLTRB(340, 0, 0, 160),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              width: 60,
              // height: 80,
              child: PopupMenuButton<Menu>(
                  color: Theme.of(context).primaryColorDark,
                  // Callback that sets the selected popup menu item.
                  onSelected: (Menu item) {
                    setState(() {
                      _selectedMenu = item.name;
                      if (item.index == 0) {
                        DeleteText(data);
                      } else if (item.index == 1) {}
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
                        const PopupMenuItem<Menu>(
                          value: Menu.edit,
                          child: Text('Edit'),
                        ),
                      ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> DeleteText(Map<String, dynamic> data) async {
    User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(user!.uid.toString())
        .collection('Texts')
        .doc(data['Title'].toString())
        .delete();
  }

  Future<void> EditText(Map<String, dynamic> data) async {
    User? user = FirebaseAuth.instance.currentUser;
  }
}
