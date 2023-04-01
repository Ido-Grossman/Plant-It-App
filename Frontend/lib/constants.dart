import 'package:flutter/material.dart';

class Consts {
  // API prefix link
  static var prefixLink = 'http://10.0.2.2:8000/';

  // colors
  static var primaryColor = Color.fromARGB(255, 31, 85, 56);
  static var lessBlack = Colors.black54;

  // Intro screen texts
  static var firstTitle = "Your perfect app for your plants!";
  static var firstSubTitle = "Make it easier for you to maintain your plant(s) with our guides.";
  static var secondTitle = "Did your plant go sick?";
  static var secondSubTitle = "Take a picture and we will help you take care of it.";
  static var thirdTitle = "Searching for a new plant?";
  static var thirdSubTitle = "Search for a new soulmate here.";

  // Error msgs
  static var errorTitle = 'Error';

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