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
      backgroundColor: Colors.white.withOpacity(0.3),
      body: TextBody(
        data: data,
      ),
    );
  }
}    
      
      /*CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: darkBlue,
            expandedHeight: 500.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(children: [
                Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.maxFinite,
                      height: 520,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(data['Image']),
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40)),
                      ),
                    )),
                Positioned(
                    left: 00,
                    right: 0,
                    top: 340,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 14.0, right: 10, top: 10),
                        child: RichText(
                          maxLines: 2,
                          strutStyle: StrutStyle(fontSize: 20.0),
                          text: TextSpan(
                            text: data['Title'],
                            style: GoogleFonts.dosis(
                                color: Color.fromARGB(255, 39, 39, 39),
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                                textStyle: TextStyle(wordSpacing: 4.5)),
                          ),
                        ),
                      ),
                      width: double.maxFinite,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40)),
                      ),
                    )),
                Positioned(
                    left: 0,
                    right: 0,
                    top: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40)),
                          ),
                          child: IconButton(
                            icon: Icon(
                              CupertinoIcons.arrowshape_turn_up_right,
                              color: Colors.white,
                            ),
                            iconSize: 30,
                            onPressed: () {},
                          ),
                        ),
                        Gap(10),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40)),
                            ),
                            child: IconButton(
                              icon: Icon(
                                CupertinoIcons.heart,
                                color: Colors.white,
                              ),
                              iconSize: 30,
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    )),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top: 40, left: 10, right: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        textWidthBasis: TextWidthBasis.parent,
                        strutStyle: StrutStyle(fontSize: 20.0),
                        text: TextSpan(
                          text: data['Text'],
                          style: GoogleFonts.merriweather(
                              color: Color.fromARGB(255, 39, 39, 39),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              textStyle: TextStyle(wordSpacing: 4.5)),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        // color: Color.fromARGB(255, 255, 255, 255),
                        ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      /* Column(children: [


           Flexible(
          flex: 7,
          child: Stack(children: [
            Positioned(
                left: 0,
                right: 0,
                child: Container(
                  width: double.maxFinite,
                  height: 510,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(data['Image']),
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                  ),
                )),
            Positioned(
                left: 00,
                right: 0,
                top: 340,
                child: Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 14.0, right: 10, top: 10),
                    child: RichText(
                      maxLines: 2,
                      strutStyle: StrutStyle(fontSize: 20.0),
                      text: TextSpan(
                        text: data['Title'],
                        style: GoogleFonts.dosis(
                            color: Color.fromARGB(255, 39, 39, 39),
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            textStyle: TextStyle(wordSpacing: 4.5)),
                      ),
                    ),
                  ),
                  width: double.maxFinite,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                  ),
                )),
            Positioned(
                left: 0,
                right: 0,
                top: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40)),
                      ),
                      child: IconButton(
                        icon: Icon(
                          CupertinoIcons.arrowshape_turn_up_right,
                          color: Colors.white,
                        ),
                        iconSize: 30,
                        onPressed: () {},
                      ),
                    ),
                    Gap(10),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
                        ),
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.heart,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                )),
          ]),
        ),
        Flexible(
          flex: 4,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.only(top: 40, left: 10, right: 10),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: RichText(
                  textAlign: TextAlign.justify,
                  textWidthBasis: TextWidthBasis.parent,
                  strutStyle: StrutStyle(fontSize: 20.0),
                  text: TextSpan(
                    text: data['Text'],
                    style: GoogleFonts.merriweather(
                        color: Color.fromARGB(255, 39, 39, 39),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        textStyle: TextStyle(wordSpacing: 4.5)),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  // color: Color.fromARGB(255, 255, 255, 255),
                  ),
            ),
          ),
        ),
      ]
      ),*/
    );
  }
}
*/