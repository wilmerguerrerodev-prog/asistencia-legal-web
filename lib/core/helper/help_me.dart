
import 'package:flutter/foundation.dart';

const logTag = "[getdash]";
const logEnable = true;
DateTime? loginClickTime;

printLog(dynamic data) {
  if (logEnable) {
    if (kDebugMode) {
      print("$logTag${data.toString()}");
    }
  }
}
