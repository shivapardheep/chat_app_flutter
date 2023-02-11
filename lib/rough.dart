import 'package:chat_app/classes/user_stream_class.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final UserStreamClass obj;

  const ChatScreen({super.key, required this.obj});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: height * 0.08,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.obj.photo.toString()),
              ),
            ),
            SizedBox(
              width: width * 0.35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.obj.name.toString(),
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    "online",
                    style: TextStyle(fontSize: 12, color: Colors.white60),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
              child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (context, i) {
                    return const Text("shiva");
                  })),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.emoji_emotions_outlined)),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.attach_file)),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.camera_alt)),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ),
            CircleAvatar(
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.mic)))
          ]),
        ],
      ),
    );
  }
}
