import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class FlowWidget extends StatefulWidget {
  String? author;
  String? title;
  String? desc;
  String? text;
  String? url;
  FlowWidget(
      {required this.author,
      required this.title,
      required this.desc,
      required this.text,
      required this.url});

  @override
  State<FlowWidget> createState() => _FlowWidgetState(
      author: this.author,
      title: this.title,
      desc: this.desc,
      text: this.text,
      url: this.url);
}

class _FlowWidgetState extends State<FlowWidget> {
  String? author;
  String? title;
  String? desc;
  String? text;
  String? url;
  _FlowWidgetState(
      {required this.author,
      required this.title,
      required this.desc,
      required this.text,
      required this.url});

  @override
  Widget build(BuildContext context) {
    print(url!);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.amber,
      child: Container(
        height: 200,
        color: Colors.amber,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: url!,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),

              /* FadeInImage.memoryNetwork(
                imageCacheWidth: MediaQuery.of(context).size.width.toInt(),
                imageCacheHeight: 200,
                fadeOutDuration: Duration(milliseconds: 300),
                fadeInDuration: Duration(milliseconds: 70),
                placeholder: kTransparentImage,
                image: url.toString(),
                imageErrorBuilder: (context, error, stackTrace) {
                  print(error);
                  return Text(error.toString());
                },
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.fill,
              ),*/
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white.withOpacity(0.4),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title.toString().toUpperCase(),
                        style: TextStyle(fontSize: 10),
                      ),
                      RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(fontSize: 12.0),
                          text: TextSpan(
                            text: desc.toString(),
                            style: TextStyle(
                              color: Color.fromARGB(255, 251, 61, 61),
                              fontSize: 20,
                            ),
                          )

                          //style: TextStyle(fontSize: 50),
                          ),
                      Text(
                        author.toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
