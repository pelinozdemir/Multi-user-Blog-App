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

class UserBlogText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserBlogText();
}

class _UserBlogText extends State<UserBlogText> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.uid.toString());
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Posts')
        .doc(user.uid.toString())
        .collection('Texts')
        .snapshots();
    print(_usersStream);
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StaggeredGrid.count(
            crossAxisSpacing: 20,
            crossAxisCount: 1,
            mainAxisSpacing: 20,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return UserTextWidget(data);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget UserTextWidget(Map<String, dynamic> data) {
    String _selectedMenu = '';
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TextPage(
            data: data,
          ),
        ));
      },
      child: Container(
        color: Color.fromARGB(255, 193, 190, 190),
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        /*decoration: new BoxDecoration(color: whitecoffee,
         gradient: new LinearGradient(
              colors: [babypink, whitecoffee],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),*/
        height: 200,
        child: Stack(
          children: [
            Container(
              // color: Colors.red,
              margin: EdgeInsets.fromLTRB(360, 0, 0, 160),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              width: 60,
              // height: 80,
              child: PopupMenuButton<Menu>(
                  // Callback that sets the selected popup menu item.
                  onSelected: (Menu item) {
                    setState(() {
                      _selectedMenu = item.name;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                        const PopupMenuItem<Menu>(
                          value: Menu.delete,
                          child: Text('Delete'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.edit,
                          child: Text('Edit'),
                        ),
                      ]),
            ),
            // LikesComment();
            Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(20, 45, 10, 30),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              width: 100,
              height: 180,
              child: CachedNetworkImage(
                imageUrl: data['Image']!,
                width: MediaQuery.of(context).size.width,
                // height: 0,
                fit: BoxFit.cover,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            Container(
              color: Colors.white,

              // color: Colors.red,
              margin: EdgeInsets.fromLTRB(120, 45, 20, 30),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 150,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 15),
                    child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 10.0),
                        text: TextSpan(
                          text: data['Title'].toString()[0].toUpperCase() +
                              data['Title']
                                  .toString()
                                  .substring(1)
                                  .toLowerCase(),
                          style: GoogleFonts.dosis(
                              color: Color.fromARGB(255, 39, 39, 39),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 0, top: 15, right: 100),
                    child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 10.0),
                        text: TextSpan(
                          text: data['Date'],
                          style: GoogleFonts.dosis(
                              color: Color.fromARGB(255, 39, 39, 39),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
            ),
            /* Positioned(
                left: 100,
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 255, 254, 254)
                              .withOpacity(0.3)),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 13, left: 3, right: 3),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 10.0),
                                  text: TextSpan(
                                    text: data['Title']
                                            .toString()[0]
                                            .toUpperCase() +
                                        data['Title']
                                            .toString()
                                            .substring(1)
                                            .toLowerCase(),
                                    style: GoogleFonts.dosis(
                                        color: Color.fromARGB(255, 39, 39, 39),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  )

                                  //style: TextStyle(fontSize: 50),
                                  ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),*/
          ],
        ),
      ),
    );
  }

  // Widget LikesComment();
}
