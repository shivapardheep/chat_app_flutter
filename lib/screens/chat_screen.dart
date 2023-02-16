import 'dart:io';

import 'package:chat_app/allConstants/color_constants.dart';
import 'package:chat_app/classes/user_stream_class.dart';
import 'package:chat_app/functions/push_notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../allWidgets/messageBox.dart';
import '../functions/utilits.dart';

class ChatScreen extends StatefulWidget {
  final User currentUser;
  final UserStreamClass obj;

  const ChatScreen({super.key, required this.obj, required this.currentUser});
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
        .doc(FunctionalityClass.createChatId(sid, rid))
        .collection("messages");
    return query
        .doc()
        .set({"sender_id": sid, "msg": msg, "timestamp": time})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  deleteChat() async {
    print(
        "---------------------------id is :${FunctionalityClass.createChatId(user!.uid, widget.obj.userid)}");
    CollectionReference delRef = FirebaseFirestore.instance.collection('chats');
    QuerySnapshot querySnapshot = await delRef
        .doc(FunctionalityClass.createChatId(user!.uid, widget.obj.userid))
        .collection("messages")
        .get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference
          .delete()
          .then((value) => debugPrint("deleted Successfully"))
          .catchError((onError) {
        print("error is : ${onError}");
      });
    }

    // await delRef
    //     .doc(FunctionalityClass.getId(user!.uid, widget.obj.userid))
    //     // .doc("UE252UOxeQarTW9CTgbEw2IWW042wh3csTqEesU3Ym4jNhXM5CSSq8F3")
    //     .delete()
  }

  goToLastChat() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery).then((file) {
      if (file != null) {
        uploadImage(File(file.path));
      }
    });
    // if (image != null) {
    //   FirebaseStorage.instance.ref("");
    // }
  }

  uploadImage(File file) async {
    String fileName = const Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child("images").child("$fileName.jpg");
    var uploadTask = await ref.putFile(file);
    String imageUrl = await uploadTask.ref.getDownloadURL();
    debugPrint(imageUrl);
    addUser(user!.uid, widget.obj.userid, imageUrl, DateTime.now());
    print("image url : $imageUrl");
    PushNotificationService()
        .sendNotificationImg(widget.obj, imageUrl, widget.currentUser);
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
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
                            .doc(widget.obj.userid)
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
        actions: [
          const Icon(Icons.video_call),
          const SizedBox(width: 20),
          const Icon(Icons.phone),
          const SizedBox(width: 5),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the selected value
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: const Text('Clear char'),
                onTap: () {
                  deleteChat();
                },
              ),
              PopupMenuItem(
                value: 'item2',
                child: Text('Settings'),
                onTap: () {},
              ),
              PopupMenuItem(
                value: 'item3',
                child: Text('logout'),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(FunctionalityClass.createChatId(
                    user!.uid.toString(), widget.obj.userid.toString()))
                .collection("messages")
                .orderBy("timestamp", descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  return ChatWidget(data, context, user);
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
                          onPressed: () {
                            pickImage();
                          },
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
                    onPressed: () async {
                      if (chatController.text != "") {
                        addUser(user!.uid, widget.obj.userid,
                            chatController.text, DateTime.now());
                        // scroll to Last
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                        // push notification
                        PushNotificationService().sendNotificationMsg(
                            widget.obj,
                            chatController.text.toString(),
                            widget.currentUser);
                        chatController.clear();
                      }
                    },
                    icon: const Icon(Icons.send)))
          ]),
        ],
      ),
    );
  }
}
