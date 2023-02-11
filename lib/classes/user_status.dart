import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatusStream {
  bool? status;
  Timestamp? lastActive;

  UserStatusStream({this.status, this.lastActive});

  UserStatusStream.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    lastActive = json['lastActive'] ??
        Timestamp.fromMicrosecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch);
  }
}
