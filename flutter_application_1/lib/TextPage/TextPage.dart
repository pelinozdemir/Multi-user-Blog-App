import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Colors/Theme.dart';
import 'package:flutter_application_1/TextPage/TextBody.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TextPage extends StatefulWidget {
  @override
  Map<String, dynamic> data;
  TextPage({required this.data});
  State<StatefulWidget> createState() => _TextPage(data: this.data);
}

class _TextPage extends State<TextPage> {
  Map<String, dynamic> data;
  _TextPage({required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white.withOpacity(0.3),
      body: TextBody(
        data: data,
      ),
    );
  }
}
