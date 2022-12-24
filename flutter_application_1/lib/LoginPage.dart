import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Signin.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'SignUp.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 32, 153, 193),
        body: LiquidSwipe(
          enableSideReveal: true,
          slideIconWidget: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          pages: [SignIn(), SignUp()],
        ));
  }
}
