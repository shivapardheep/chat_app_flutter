// import 'package:chat_app/allConstants/color_constants.dart';
// import 'package:chat_app/classes/user_stream_class.dart';
// import 'package:chat_app/screens/auth_screen.dart';
// import 'package:chat_app/screens/chat_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';
//
// import '../allWidgets/drawer_widget.dart';
// import '../functions/utilits.dart';
// import '../main.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
//   final user = FirebaseAuth.instance.currentUser;
//   CollectionReference fireStore =
//   FirebaseFirestore.instance.collection("users");
//
//   navToAuth() {
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const AuthScreen()),
//             (route) => false);
//   }
//
//   navToChat(obj) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (_) => ChatScreen(
//               obj: obj,
//               currentUserId: user!.uid,
//             )));
//   }
//
//   void showFlutterNotification(RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channel.description,
//             color: ColorConstants.primaryColor,
//             playSound: true,
//             // TODO add a proper drawable resource to android, for now using
//             //      one that already exists in example app.
//             icon: '@mipmap/ic_launcher',
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     fireStore
//         .doc(user!.email.toString())
//         .update({"status": true})
//         .then((value) {})
//         .catchError((error) => debugPrint(
//         "-------------------------------------Failed to add user: $error"));
//     super.initState();
//     FirebaseMessaging.onMessage.listen(showFlutterNotification);
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//
//     });
//   }
// }
//
// @override
// void didChangeAppLifecycleState(AppLifecycleState state) {
//   if (state == AppLifecycleState.resumed) {
//     // User is now back in the app, you can set the user's online status as "online"
//     fireStore
//         .doc(user!.email.toString())
//         .update({"status": true})
//         .then((value) =>
//         print("----------------------------------------status updated"))
//         .catchError((error) => print(
//         "-------------------------------------Failed to add user: $error"));
//   } else {
//     // User has left the app, you can set the user's online status as "offline"
//     fireStore
//         .doc(user!.email.toString())
//         .update({"status": false})
//         .then((value) => print("--status updated"))
//         .catchError((error) => print(
//         "-------------------------------Failed to add user: $error"));
//   }
// }
//
// @override
// void dispose() {
//   WidgetsBinding.instance.removeObserver(this);
//   fireStore
//       .doc(user!.email.toString())
//       .update({"status": false})
//       .then((value) =>
//       print("----------------------------------------User Added"))
//       .catchError((error) => print(
//       "-------------------------------------Failed to add user: $error"));
//   super.dispose();
// }
//
// @override
// Widget build(BuildContext context) {
//   List<UserStreamClass> data = context.watch<List<UserStreamClass>>();
//
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//   ));
//   return Scaffold(
//     extendBodyBehindAppBar: true,
//     drawer: drawerWidget(context, user),
//     appBar: AppBar(
//       shadowColor: Colors.transparent,
//       centerTitle: true,
//       title: const Text("WhatsApp"),
//       actions: [
//         IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
//         PopupMenuButton<String>(
//           onSelected: (value) {
//             // Handle the selected value
//           },
//           itemBuilder: (context) => [
//             PopupMenuItem(
//               value: 'addGroup',
//               child: const Text('create group'),
//               onTap: () {},
//             ),
//             PopupMenuItem(
//               value: 'item2',
//               child: Text('Settings'),
//               onTap: () {},
//             ),
//             PopupMenuItem(
//               value: 'item3',
//               child: Text('logout'),
//               onTap: () {},
//             ),
//           ],
//         ),
//       ],
//     ),
//     body: ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (context, i) {
//           return InkWell(
//             onTap: () {
//               navToChat(data[i]);
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5),
//               child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(data[i].photo.toString()),
//                   maxRadius: 30,
//                 ),
//                 title: Text(data[i].name.toString()),
//                 subtitle: Text(data[i].email.toString()),
//                 trailing: Text(
//                   FunctionalityClass.timestampToTimeString(
//                       data[i].lastLoginTime),
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             ),
//           );
//         }),
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {},
//       child: const Icon(
//         Icons.message,
//         color: Colors.white,
//       ),
//     ),
//   );
// }
// }
