import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  void errorMassage({required String massage}) {
    Fluttertoast.showToast(
      msg: massage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: (massage == "Sign up successfully" ||
          massage == "Login successfully" ||
          massage == "Post successfully added...")
          ? Colors.green
          : Colors.red,
      textColor: Colors.white,
      fontSize: 11,
    );
  }
}