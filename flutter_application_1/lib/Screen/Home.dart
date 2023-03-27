import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/Screen/AddScreen/AddNew.dart';
import 'package:flutter_application_1/Screen/DiscvoverScreen/DiscoverPage.dart';
import 'package:flutter_application_1/Screen/MessageScreen/MessageList.dart';
import 'package:flutter_application_1/Screen/MessageScreen/Messages.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_application_1/Screen/HomeScreen/blogPage.dart';
import 'package:flutter_application_1/Screen/UserProfileScreen/UsersProfile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import 'ProfileScreen/Profile.dart';
import 'ProfileScreen/ornek.dart';

class Home extends StatefulWidget {
  String searching_name;
  Home({required this.searching_name});
  @override
  State<Home> createState() => _HomeState(searching_name: searching_name);
}

class _HomeState extends State<Home> {
  static const Icon compass = Icon(IconData(0xf8ca));
  PageController controller = PageController();
  int currentIndex = 0;
  String searching_name;
  _HomeState({required this.searching_name});
  List<Icon> icons = [
    Icon(Icons.home),
    compass,
    Icon(Icons.message),
    Icon(Icons.person)
  ];
  List<StatefulWidget> screens = [];

  List<StatefulWidget> getScreens() {
    screens.add(BlogPage());
    screens.add(Discover(
      topicindex: 0,
    ));
    screens.add(MessageListScreen());
    screens.add(Profile());
    screens.add(AddNew());

    return screens;
  }

  @override
  void initState() {
    // TODO: implement initState
    getScreens();
    super.initState();
  }

  void OnTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  var heart = false;

  @override
  Widget build(BuildContext context) {
    //getScreens();
    /*SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));*/
    return Scaffold(
      extendBody: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(
        children: screens,
        controller: controller,
        physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
      ),
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        items: [
          BottomBarItem(
              icon: const Icon(
                Icons.home_outlined,
              ),
              unSelectedColor: Theme.of(context).canvasColor,
              selectedIcon: const Icon(Icons.home_rounded),
              selectedColor: Colors.teal,
              backgroundColor: Colors.tealAccent,
              title: Text(
                'Home',
                style: GoogleFonts.dosis(fontSize: 14),
              )),
          BottomBarItem(
              icon: const Icon(CupertinoIcons.compass),
              selectedIcon: const Icon(CupertinoIcons.compass_fill),
              unSelectedColor: Theme.of(context).canvasColor,
              backgroundColor: Colors.purpleAccent,
              selectedColor: Colors.pinkAccent,
              title: Text('Discover', style: GoogleFonts.dosis(fontSize: 14))),
          BottomBarItem(
              icon: const Icon(
                Icons.message_outlined,
              ),
              selectedIcon: const Icon(
                Icons.message_rounded,
              ),
              backgroundColor: Colors.amber,
              unSelectedColor: Theme.of(context).canvasColor,
              selectedColor: Colors.deepOrangeAccent,
              title: Text('Message', style: GoogleFonts.dosis(fontSize: 14))),
          BottomBarItem(
            icon: const Icon(
              Icons.person_outline,
            ),
            selectedIcon: const Icon(
              Icons.person,
            ),
            selectedColor: Colors.green,
            unSelectedColor: Theme.of(context).canvasColor,
            backgroundColor: Colors.lightGreenAccent,
            title: Text('Profile', style: GoogleFonts.dosis(fontSize: 14)),
          )
        ],
        hasNotch: false,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: currentIndex,
        onTap: (index) {
          controller.jumpToPage(index);
          setState(() {
            heart = true;
            currentIndex = index;
          });
        },
        option: AnimatedBarOptions(
          // inkColor: Colors.amber,
          // iconSize: 32,
          barAnimation: BarAnimation.liquid,
          iconStyle: IconStyle.animated,
          // opacity: 0.3,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            heart = !heart;
            controller.jumpToPage(4);
          });
        },
        backgroundColor: orange,
        child: Icon(
          heart ? CupertinoIcons.add_circled : CupertinoIcons.add_circled_solid,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /*  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Material()),
          Expanded(child: Material()),
          Expanded(child: const SizedBox()), // this will handle the fab spacing
          Expanded(child: Material()),
          Expanded(child: Material()),
        ])*/

      /*ClipRRect(
        borderRadius: BorderRadius.circular(3.0),
        child: BottomNavigationBarTheme(
          data: Theme.of(context).bottomNavigationBarTheme,
          child: BottomNavigationBar(
            // backgroundColor: Colors.amber,
            onTap: _onItemTap,
            currentIndex: currentIndex,
            //  selectedItemColor: Colors.black,
            //  unselectedItemColor: Color.fromARGB(255, 129, 124, 124),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
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
      ),*/
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
