import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../classes/user_stream_class.dart';

class PushNotificationService {
  Future<void> sendNotificationMsg(
    UserStreamClass obj,
    msg,
    User currentUser,
  ) async {
    try {
      OneSignal.shared
          .postNotification(OSCreateNotification(
            playerIds: [obj.oneSignalId.toString()],
            heading: currentUser.displayName,
            content: msg,
            // bigPicture:
            //     "https://www.simplilearn.com/ice9/free_resources_article_thumb/white_hat_hacker.jpg",
          ))
          .then((value) =>
              debugPrint("Message Send Successfully................"));
    } catch (e) {
      print("OneSignal Error :  : ${e.toString()}");
    }
  }

  Future<void> sendNotificationImg(
    UserStreamClass obj,
    String img,
    User currentUser,
  ) async {
    print("-------------------------------------------------------------");
    print(currentUser.displayName);
    print(obj.oneSignalId);
    try {
      OneSignal.shared
          .postNotification(OSCreateNotification(
            playerIds: [obj.oneSignalId.toString()],
            heading: currentUser.displayName,
            bigPicture: img.toString(),
            content: 'image',
          ))
          .then((value) =>
              debugPrint("Message Send Successfully................"));
    } catch (e) {
      print("OneSignal Error :  : ${e.toString()}");
    }
  }
}
