import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Screen/AddScreen/AddNew.dart';
import 'package:flutter_application_1/TextPage/TextPage.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class DiscoverWidget extends StatefulWidget {
  int? count;
  Map<String, dynamic> data;
  DiscoverWidget({required this.data, required this.count});

  @override
  State<DiscoverWidget> createState() =>
      _DiscoverWidgetState(data: this.data, count: this.count);
}

class _DiscoverWidgetState extends State<DiscoverWidget> {
  int? count;
  Map<String, dynamic> data;
  _DiscoverWidgetState({required this.data, required this.count});
  bool? istap = false;
  @override
  Widget build(BuildContext context) {
    var rng = Random();
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TextPage(
            data: this.data,
          ),
        ));
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(microseconds: 10),
            height: (count! % 5) * 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: data['Image']!,
                    width: MediaQuery.of(context).size.width,
                    height: (count! % 5) * 125,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 10.0),
                        text: TextSpan(
                          text: data['Title'].toString()[0].toUpperCase() +
                              data['Title']
                                  .toString()
                                  .substring(1)
                                  .toLowerCase(),
                          style: GoogleFonts.dosis(
                              color: Theme.of(context).canvasColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        )

                        //style: TextStyle(fontSize: 50),
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    width: double.infinity,
                    child: RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                          text: data['Author'].toString(),
                          style: GoogleFonts.dosis(
                              color: Theme.of(context).cardColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        )),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
