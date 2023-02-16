import 'package:chat_app/classes/user_stream_class.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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
                  currentUser: user!,
                )));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // navToChat();
      // List<UserStreamClass> data = context.watch<List<UserStreamClass>>();
      // for (var i in data) {
      //   if (i.name == result.notification.title) {
      //     navToChat(i);
      //     print("matching........................................");
      //   }
      // }
      // print("No matching");

      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text(result.notification.title.toString()),
      //         content: Text(result.notification.body.toString()),
      //       );
      //     });
      // Will be called whenever a notification is opened/button pressed.
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });
    // Set the user's subscription status to true
    // OneSignal.shared.setSubscription(true);

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges status) {});

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });

    fireStore.doc(user!.uid.toString()).update({"status": true}).then((value) {
      print("init----------------------------------added Successfully");
    }).catchError((error) => debugPrint(
        "init-------------------------------------Failed to add user: $error"));

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User is now back in the app, you can set the user's online status as "online"
      fireStore
          .doc(user!.uid.toString())
          .update({"status": true})
          .then((value) => print(
              "didChange----------------------------------------status updated"))
          .catchError((error) => print(
              "didChange-------------------------------------Failed to add user: $error"));
    } else {
      // User has left the app, you can set the user's online status as "offline"
      fireStore
          .doc(user!.uid.toString())
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
        .doc(user!.uid.toString())
        .update({"status": false})
        .then((value) =>
            print("dispose----------------------------------------User Added"))
        .catchError((error) => print(
            "dispose-------------------------------------Failed to add user: $error"));
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
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the selected value
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'addGroup',
                child: const Text('create group'),
                onTap: () {},
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
