import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/Screen/AddScreen/AddNew.dart';
import 'package:flutter_application_1/Screen/DiscvoverScreen/DiscoverPage.dart';
import 'package:flutter_application_1/Screen/MessageScreen/Messages.dart';

import 'package:flutter_application_1/Screen/HomeScreen/blogPage.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'ProfileScreen/Profile.dart';
import 'ProfileScreen/ornek.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const Icon compass = Icon(IconData(0xf8ca));
  List<StatefulWidget> screens = [
    BlogPage(),
    Discover(),
    AddNew(),
    Messages(),
    Profile()
  ];
  int currentIndex = 0;

  void OnTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.white,
      /*  drawer: Drawer(
          elevation: 0,
          backgroundColor: Colors.black,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Çıkış"),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Çıkış"),
              ),
              ListTile(),
            ],
          )),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.brown),
        /* actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false));
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false));
            },
          ),
        ],*/
      ),*/
      body: _pageCaller(currentIndex),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(3.0),
        child: BottomNavigationBar(
          onTap: _onItemTap,
          currentIndex: currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Color.fromARGB(255, 129, 124, 124),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: 'Discover'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
              ),
              label: 'Add',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message_outlined,
                ),
                label: 'Messages'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }

  void _onItemTap(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  Widget _pageCaller(int value) {
    return screens[value];
  }
}
