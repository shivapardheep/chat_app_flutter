import 'package:chat_app/allConstants/color_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth_screen.dart';

Drawer drawerWidget(BuildContext context, user) {
  navToAuth() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false);
  }

  logout() async {
    await FirebaseAuth.instance.signOut().then((value) => navToAuth());
  }

  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: ColorConstants.primaryColor,
          ), //BoxDecoration
          child: UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: ColorConstants.primaryColor),
            accountName: Text(
              user!.displayName.toString(),
              style: const TextStyle(fontSize: 18),
            ),
            accountEmail: Text(user!.email.toString()),
            currentAccountPictureSize: const Size.square(50),
            currentAccountPicture: CircleAvatar(
              radius: 60.0,
              backgroundColor: const Color(0xFF778899),
              backgroundImage:
                  NetworkImage(user!.photoURL.toString()), // for Network image
            ), //circleAvatar
          ), //UserAccountDrawerHeader
        ), //DrawerHeader
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text(' My Profile '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.book),
          title: const Text(' My Course '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.workspace_premium),
          title: const Text(' Go Premium '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.video_label),
          title: const Text(' Saved Videos '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text(' Edit Profile '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('LogOut'),
          onTap: () {
            logout();
          },
        ),
      ],
    ),
  );
}
