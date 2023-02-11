import 'package:cloud_firestore/cloud_firestore.dart';

class ChatStreamClass {
  String? message;
  String? senderId;
  Timestamp? time;

  ChatStreamClass(
      {required this.message, required this.senderId, required this.time});

  ChatStreamClass.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    senderId = json['sender_id'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['sender_id'] = senderId;
    data['time'] = time;
    return data;
  }
}
