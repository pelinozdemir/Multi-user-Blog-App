import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Colors/Palette.dart';
import 'package:flutter_application_1/Screen/DiscvoverScreen/DiscoverPage.dart';
import 'package:flutter_application_1/Tags/BlogTopic.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicTag extends StatefulWidget {
  int topicindex;
  TopicTag({required this.topicindex});
  @override
  State<StatefulWidget> createState() => _TopicTags(topicindex: topicindex);
}

class _TopicTags extends State<TopicTag> {
  int topicindex;
  _TopicTags({required this.topicindex});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      padding: EdgeInsets.all(8),
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print(topic[index]);
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Discover(topicindex: index),
                    ));*/
              },
              child: AnimatedContainer(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(1),
                width: topicindex == index ? 90 : 100,
                height: topicindex == index ? 16 : 18,
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: topicindex == index
                      ? Theme.of(context).canvasColor
                      : Colors.transparent,
                  borderRadius: topicindex == index
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(10),
                  border: topicindex == index
                      ? Border.all(color: darkBlue, width: 2)
                      : null,
                ),
                child: Center(
                  //style: TextStyle(fontSize: 50),

                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      textAlign: TextAlign.center,
                      topic[index],
                      style: GoogleFonts.dosis(
                          fontWeight: FontWeight.w500,
                          color: topicindex == index
                              ? Colors.white
                              : Theme.of(context).canvasColor,
                          fontSize: topicindex == index ? 14 : 15.5),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, index) => SizedBox(
                width: 10,
              ),
          itemCount: topic.length),
    );
  }
}
