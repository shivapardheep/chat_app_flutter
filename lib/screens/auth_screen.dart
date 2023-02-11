import 'package:chat_app/allConstants/constants.dart';
import 'package:chat_app/auth/google_signin.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  navToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    ConstData.isLoading = true;
                  });
                  await AuthServices().signInWithGoogle();
                  final firebaseAuth = FirebaseAuth.instance.currentUser;
                  if (firebaseAuth != null) {
                    setState(() {
                      ConstData.isLoading = false;
                    });
                    return navToHome();
                  }
                  return;
                },
                icon: const Icon(Icons.g_mobiledata_sharp),
                label: const Text("Sign in")),
            ConstData.isLoading
                ? Container(
                    height: height,
                    width: width,
                    color: Colors.transparent,
                    child: const Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 10, color: Colors.deepOrange),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
