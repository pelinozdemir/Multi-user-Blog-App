import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Home.dart';
import 'package:flutter_application_1/SignUp.dart';

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
              MaterialPageRoute(builder: (context) => Home()),
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
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: mail,
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              controller: password,
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: (() async {
                signIn();
              }),
              child: Text('GİRİŞ YAP', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }
}
