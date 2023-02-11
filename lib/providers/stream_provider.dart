import 'package:chat_app/classes/user_stream_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreamProviderService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Stream<List<UserStreamClass>> usersStreamData() {
    return fireStore
        .collection("users")
        .where("email", isNotEqualTo: user!.email.toString())
        .snapshots()
        .map((QuerySnapshot snapShot) => snapShot.docs
            .map((doc) =>
                UserStreamClass.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
