import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FunctionalityClass {
  static String createChatId(myId, obj) {
    if (myId.compareTo(obj) != 1) {
      return "$myId$obj";
    } else {
      return "$obj$myId";
    }
  }

  static String timestampToTimeString(Timestamp? timestamp) {
    var format = DateFormat('h:mm a');
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp!.millisecondsSinceEpoch);
    return format.format(date);
  }
}
