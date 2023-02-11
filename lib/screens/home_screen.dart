import 'package:chat_app/classes/user_stream_class.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../allWidgets/drawer_widget.dart';
import '../functions/utilits.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference fireStore =
      FirebaseFirestore.instance.collection("users");

  navToAuth() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false);
  }

  navToChat(obj) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChatScreen(
                  obj: obj,
                  currentUserId: user!.uid,
                )));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    fireStore
        .doc(user!.email.toString())
        .update({"status": true})
        .then((value) =>
            print("----------------------------------------User upadted"))
        .catchError((error) => print(
            "-------------------------------------Failed to add user: $error"));
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User is now back in the app, you can set the user's online status as "online"
      fireStore
          .doc(user!.email.toString())
          .update({"status": true})
          .then((value) =>
              print("----------------------------------------status updated"))
          .catchError((error) => print(
              "-------------------------------------Failed to add user: $error"));
    } else {
      // User has left the app, you can set the user's online status as "offline"
      fireStore
          .doc(user!.email.toString())
          .update({"status": false})
          .then((value) => print("--status updated"))
          .catchError((error) => print(
              "-------------------------------Failed to add user: $error"));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    fireStore
        .doc(user!.email.toString())
        .update({"status": false})
        .then((value) =>
            print("----------------------------------------User Added"))
        .catchError((error) => print(
            "-------------------------------------Failed to add user: $error"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<UserStreamClass> data = context.watch<List<UserStreamClass>>();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: drawerWidget(context, user),
      appBar: AppBar(
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: const Text("WhatsApp"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                navToChat(data[i]);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data[i].photo.toString()),
                    maxRadius: 30,
                  ),
                  title: Text(data[i].name.toString()),
                  subtitle: Text(data[i].email.toString()),
                  trailing: Text(
                    FunctionalityClass.timestampToTimeString(
                        data[i].lastLoginTime),
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
    );
  }
}
