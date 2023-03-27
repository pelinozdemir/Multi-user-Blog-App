import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Colors/Theme.dart';
import 'package:flutter_application_1/Colors/ThemeColor.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/Screen/AddScreen/AddNew.dart';
import 'package:flutter_application_1/Screen/DiscvoverScreen/DiscoverPage.dart';
import 'package:flutter_application_1/Screen/DiscvoverScreen/Searchbar.dart';
import 'package:flutter_application_1/Screen/Home.dart';
import 'package:flutter_application_1/TextPage/TextPage.dart';
import 'package:flutter_application_1/models/changeicon.dart';
import 'package:flutter_application_1/models/changetheme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ColorThemeData().createPrefObject();
  await ItemData().createPrefObject();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ItemData>(
        create: (BuildContext context) => ItemData()),
    ChangeNotifierProvider<ColorThemeData>(
        create: (context) => ColorThemeData())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialAppTheme();
  }
}

class MaterialAppTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ColorThemeData>(context).loadThemeFromSharedPref();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new Home(searching_name: ""),
          '/search': (BuildContext context) => new SearchBar(),
          '/discover': (BuildContext context) => new Discover(
                topicindex: 0,
              ),
          '/add': (BuildContext context) => new AddNew()
        },
        theme: Provider.of<ColorThemeData>(context).selectedThemeData,
        home: Scaffold(
          body: LoginPage(),
        ));
  }
}
