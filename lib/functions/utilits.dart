import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FunctionalityClass {
  static String getId(myId, obj) {
    if (myId.compareTo(obj) != 1) {
      print("return is : $myId$obj");
      return "$myId$obj";
    } else {
      print("return is : $obj$myId");

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
