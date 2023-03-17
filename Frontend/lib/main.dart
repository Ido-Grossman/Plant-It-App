import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
