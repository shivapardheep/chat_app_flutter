import 'package:chat_app/allConstants/color_constants.dart';
import 'package:chat_app/classes/user_stream_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import '../functions/utilits.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final UserStreamClass obj;

  const ChatScreen({super.key, required this.obj, required this.currentUserId});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController chatController = TextEditingController();

  Future<void> addUser(sid, rid, msg, time) {
    // Call the user's CollectionReference to add a new user
    var query = FirebaseFirestore.instance
        .collection('chats')
        .doc(FunctionalityClass.getId(sid, rid))
        .collection("messages");
    return query
        .doc()
        .set({"sender_id": sid, "msg": msg, "timestamp": time})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  goToLastChat() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorConstants.backgroudColor,
      appBar: AppBar(
        // toolbarHeight: height * 0.08,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.obj.photo.toString()),
              ),
            ),
            Flexible(
              child: SizedBox(
                width: width * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.obj.name.toString(),
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),

                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.obj.email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("");
                          }

                          Map<String, dynamic> document =
                              snapshot.data!.data() as Map<String, dynamic>;

                          return Text(
                            document['status'] ? "Online" : "Offline",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white54),
                          );
                        })

                    // Text(
                    //   userStatus.status.toString() == "true"
                    //       ? "Online"
                    //       : "Offline",
                    //   style:
                    //       const TextStyle(fontSize: 12, color: Colors.white60),
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.video_call),
          SizedBox(width: 20),
          Icon(Icons.phone),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(FunctionalityClass.getId(
                    user!.uid.toString(), widget.obj.userid.toString()))
                .collection("messages")
                .orderBy("timestamp")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print("body calling................");
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(strokeWidth: 5));
              }

              return ListView(
                controller: _scrollController,
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ChatBubble(
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
                  // return messageBox(data, data["sender_id"] == user!.uid);
                }).toList(),
              );
            },
          )),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.emoji_emotions_outlined)),
                      Expanded(
                        child: TextField(
                          controller: chatController,
                          decoration: const InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.camera_alt)),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ),
            CircleAvatar(
                child: IconButton(
                    onPressed: () {
                      if (chatController.text != "") {
                        addUser(user!.uid, widget.obj.userid,
                            chatController.text, DateTime.now());
                        chatController.clear();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                        });
                      }
                    },
                    icon: const Icon(Icons.send)))
          ]),
        ],
      ),
    );
  }
}
