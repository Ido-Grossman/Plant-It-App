import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/logins/choosePassScreen.dart';
import 'package:frontend/logins/chooseUsernameScreen.dart';
import 'package:frontend/service/httpService.dart';
import 'package:page_transition/page_transition.dart';

import '../home/homeScreen.dart';

class GoogleLoginPage extends StatefulWidget {
  final String? email;
  final String uid;
  const GoogleLoginPage({super.key, required this.email, required this.uid});

  @override
  _GoogleLoginPageState createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    checkStatusCode();
  }

  void checkStatusCode() async {
    final token = await logInGoogle(widget.email, widget.uid);
    if (!mounted) {
      return;
    }
    if (token != 'error' && token != null) {
      Navigator.push(
          context,
          PageTransition(
              child: FirstScreen(token: token,),
              type: PageTransitionType.bottomToTop));
    } else if (token != null) {
      Navigator.push(
          context,
          PageTransition(
              child: const ChoosePassScreen(),
              type: PageTransitionType.bottomToTop));
    } else {
      Consts.alertPopup(context, Consts.cantConnect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Consts.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SpinKitFoldingCube(
              color: Colors.white,
              size: 80.0,
            ),
            SizedBox(height: 30.0),
            Text(
              'Logging in progress',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}