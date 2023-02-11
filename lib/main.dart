import 'package:chat_app/allConstants/color_constants.dart';
import 'package:chat_app/classes/user_stream_class.dart';
import 'package:chat_app/providers/stream_provider.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //     apiKey: "AIzaSyDpiBBbn3qE9ArT8JUnjL58mdAVhsynH_Q",
      //     authDomain: "chat-app-6b687.firebaseapp.com",
      //     projectId: "chat-app-6b687",
      //     storageBucket: "chat-app-6b687.appspot.com",
      //     messagingSenderId: "502771795436",
      //     appId: "1:502771795436:web:c4556fd252757bf67d2cc9",
      //     measurementId: "G-GN5V4E5NBJ"),
      );
  runApp(MultiProvider(
    providers: [
      StreamProvider<List<UserStreamClass>>(
          create: (_) => StreamProviderService().usersStreamData(),
          initialData: const []),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme:
              const AppBarTheme(backgroundColor: ColorConstants.primaryColor),
          primarySwatch: const MaterialColor(0xff128C7E, {
            50: ColorConstants.primaryColor,
            100: ColorConstants.primaryColor,
            200: ColorConstants.primaryColor,
            300: ColorConstants.primaryColor,
            400: ColorConstants.primaryColor,
            500: ColorConstants.primaryColor,
            600: ColorConstants.primaryColor,
            700: ColorConstants.primaryColor,
            800: ColorConstants.primaryColor,
            900: ColorConstants.primaryColor
          })),
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const HomeScreen();
    }

    return const AuthScreen();
  }
}
