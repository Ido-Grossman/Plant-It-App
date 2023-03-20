import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home/homeScreen.dart';

import 'intro/introScreen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intro Screen',
      home: FirstScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
