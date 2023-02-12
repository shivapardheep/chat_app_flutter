import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:photo_view/photo_view.dart';

import '../allConstants/color_constants.dart';

Widget ChatWidget(Map<String, dynamic> data, BuildContext context, user) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  return data['msg'].contains("https://")
      ? Align(
          alignment: Alignment.bottomRight,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PhotoView(imageProvider: NetworkImage(data['msg'])),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 5, right: 10, left: 10),
              height: 250,
              width: width / 2,
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.grey),
                // borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 5.0),
                  ),
                ],
              ),
              child: FadeInImage(
                placeholder: AssetImage("assets/images/mimi2.gif"),
                image: NetworkImage(data['msg']),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      // Align(
      //         alignment: Alignment.bottomRight,
      //         child: Container(
      //           margin:
      //               const EdgeInsets.only(top: 10, bottom: 5, right: 10, left: 10),
      //           height: 200,
      //           width: width / 2,
      //           decoration: BoxDecoration(
      //               border: Border.all(color: Colors.grey),
      //               borderRadius: BorderRadius.circular(10),
      //               boxShadow: const [
      //                 BoxShadow(
      //                   color: Colors.grey,
      //                   blurRadius: 10.0,
      //                   offset: Offset(0.0, 5.0),
      //                 ),
      //               ],
      //               image: DecorationImage(
      //                   image: NetworkImage(data['msg']), fit: BoxFit.cover)),
      //         ))
      : ChatBubble(
          clipper: ChatBubbleClipper8(
              type: data["sender_id"] == user!.uid
                  ? BubbleType.sendBubble
                  : BubbleType.receiverBubble),
          alignment: data["sender_id"] == user!.uid
              ? Alignment.topRight
              : Alignment.topLeft,
          margin: const EdgeInsets.only(top: 20, right: 5, left: 5),
          backGroundColor: data["sender_id"] == user!.uid
              ? ColorConstants.primaryColor
              : Colors.white,
          child: Container(
            // color: Colors.green,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Text(
              data["msg"],
              style: TextStyle(
                  color: data["sender_id"] == user!.uid
                      ? Colors.white
                      : Colors.black),
            ),
          ),
        );
}
