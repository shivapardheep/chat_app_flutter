import 'package:cloud_firestore/cloud_firestore.dart';

class UserStreamClass {
  String? name;
  String? email;
  String? userid;
  String? photo;
  Timestamp? lastLoginTime;

  UserStreamClass({
    required this.name,
    required this.email,
    required this.userid,
    required this.photo,
    required this.lastLoginTime,
  });

  UserStreamClass.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    userid = json['uid'] ?? "";
    photo = json['photo'] ?? "";
    lastLoginTime = json['lastLoginTime'] ?? "";
  }
}
