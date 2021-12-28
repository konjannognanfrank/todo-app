import 'package:flutter/material.dart';

const Color customBlue = Color.fromRGBO(47, 59, 109, 1);

Color dateColor(String date) {
  switch (date) {
    case 'Yesterday':
      return Colors.pinkAccent;
    case 'Today':
      return Colors.blueAccent;
    default:
      return customBlue;
  }
}
