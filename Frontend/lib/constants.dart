import 'dart:io';

import 'package:flutter/material.dart';

class Consts {
  // API prefix link
  static String getApiLink() {
    if (Platform.isAndroid){
      return 'http://10.0.2.2:8000/api/';
    } else {
      return 'http://127.0.0.1:8000/api/';
    }
  }

  // colors
  static var primaryColor = Color.fromARGB(255, 31, 85, 56);
  static var lessBlack = Colors.black54;
  static Color greenDark = Colors.greenAccent;
  // Intro screen texts
  static var firstTitle = "Your perfect app for your plants!";
  static var firstSubTitle = "Make it easier for you to maintain your plant(s) with our guides.";
  static var secondTitle = "Did your plant go sick?";
  static var secondSubTitle = "Take a picture and we will help you take care of it.";
  static var thirdTitle = "Searching for a new plant?";
  static var thirdSubTitle = "Search for a new soulmate here.";

  // Error msgs
  static var errorTitle = 'Error';
  static var cantConnect = "lost connection to server, Please try again.";

  // methods
  static Future<dynamic> alertPopup(BuildContext context, String reason, {String title='Error', String button='Ok'}) {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(reason),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              },
                  child: Text(button))
            ],
          );
        });
  }
}