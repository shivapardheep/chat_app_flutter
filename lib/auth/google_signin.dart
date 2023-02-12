import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential fAuth =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (fAuth.user != null) {
      firebaseLogin(fAuth);
    }
  }

  firebaseLogin(fAuth) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    await fireStore.collection("users").doc(fAuth.user!.uid).set({
      "uid": fAuth.user!.uid,
      "name": fAuth.user!.displayName,
      "email": fAuth.user!.email,
      "photo": fAuth.user!.photoURL,
      "lastLoginTime": DateTime.now(),
      "status": true,
    });
  }

  // checkUser()async{
  //   final user = FirebaseAuth.instance.currentUser;
  //
  //   return
  // }
}
