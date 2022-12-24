import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class TextBody extends StatefulWidget {
  Map<String, dynamic> data;
  TextBody({required this.data});
  @override
  State<StatefulWidget> createState() => _TextBody(data: data);
}

class _TextBody extends State<TextBody> {
  Map<String, dynamic> data;
  _TextBody({required this.data});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        Container(
          child: SliverAppBar(
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.bookmark,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.heart,
                  color: Colors.black,
                  size: 30,
                ),
              )
            ],
            backgroundColor: Colors.white,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(children: [
                Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.6,
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
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.44,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 14.0, right: 10, top: 0),
                        child: Column(children: [
                          RichText(
                            maxLines: 3,
                            strutStyle: StrutStyle(fontSize: 10.0),
                            text: TextSpan(
                              text: data['Title'],
                              style: GoogleFonts.dosis(
                                  color: Color.fromARGB(255, 39, 39, 39),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  textStyle: TextStyle(wordSpacing: 4.5)),
                            ),
                          ),
                        ]),
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
              ]),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Container(
                child: SingleChildScrollView(
                  /* child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 40, left: 10, right: 10),*/
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
                  /* decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),*/
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
