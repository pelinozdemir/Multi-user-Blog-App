import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Screen/Home.dart';
import 'package:flutter_application_1/SignUp.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail.text, password: password.text)
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(
                        searching_name: "",
                      )),
              (route) => true));
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: Text('HATA'),
              content: Text(
                  'Kullanıcı bulunamadı. Lütfen bilgileriniz doğruluğundan emin olun.'),
            )),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: MediaQuery.of(context).size.width * 1.03,
                    )),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.18,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Text("Welcome to app",
                              style: GoogleFonts.dosis(
                                fontWeight: FontWeight.w400,
                                fontSize: 35,
                                color: Colors.black26,
                              )))),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.35,
                    child: Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.76,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey.shade100),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: mail,
                                    style: GoogleFonts.dosis(
                                        fontSize: 16, color: Color(0xff9C9EB9)),
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 0.0),
                                      hintText: 'Mail',
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.76,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey.shade100),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: password,
                                    style: GoogleFonts.dosis(
                                        fontSize: 16, color: Color(0xff9C9EB9)),
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 0.0),
                                      hintText: 'Password',
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
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.76,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: orange,
                                  padding: EdgeInsets.all(8)),
                              onPressed: (() async {
                                signIn();
                              }),
                              child: Text('Login',
                                  style: GoogleFonts.dosis(
                                      fontSize: 25, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ))),
              ],
            ),
          )),
    );
  }
}


/*
 SafeArea(
          child: Center(
            child: 
            ),
          ),
        ),





 */