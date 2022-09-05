import 'dart:io';
import 'package:intl/intl.dart';

class Utils {
  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMd().format(dateTime);
    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final date = DateFormat.Hm().format(dateTime);
    return '$date';
  }
}
