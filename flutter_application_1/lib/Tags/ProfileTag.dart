import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Tags/BlogTopic.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTag extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileTags();
}

class _ProfileTags extends State<ProfileTag> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  current = index;
                });
              },
              child: AnimatedContainer(
                margin: EdgeInsets.all(0),
                // padding: EdgeInsets.all(1),
                width: current == index ? 75 : 85,
                height: current == index ? 13 : 13,
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: current == index
                      ? Color.fromARGB(179, 255, 255, 255)
                      : Color.fromARGB(159, 196, 196, 196),
                  borderRadius: current == index
                      ? BorderRadius.circular(15)
                      : BorderRadius.circular(10),
                  border: current == index
                      ? Border.all(
                          color: Color.fromARGB(255, 92, 59, 185), width: 2)
                      : null,
                ),
                child: Center(
                  //style: TextStyle(fontSize: 50),

                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      textAlign: TextAlign.center,
                      tag[index],
                      style: GoogleFonts.dosis(
                          fontWeight: FontWeight.w500,
                          color: current == index
                              ? Colors.black
                              : Color.fromARGB(255, 102, 101, 101),
                          fontSize: current == index ? 13 : 14),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, index) => SizedBox(
                width: 10,
              ),
          itemCount: tag.length),
    );
  }
}
