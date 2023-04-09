import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:frontend/service/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';

import '../constants.dart';
import '../service/httpService.dart';
import '../service/loginTextField.dart';
import 'loginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with TickerProviderStateMixin {
  String _emailTextField = '';
  bool _isLoading = false;
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this); // Add this line
  }

  @override
  void dispose() {
    _gifController.dispose(); // Add this line
    super.dispose();
  }

  _updateUsernameFieldValue(String value) {
    setState(() {
      _emailTextField = value;
    });
  }

  Future<void> onForgotPass() async {
    if (_emailTextField.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      _gifController.repeat(min: 0, max: 29, period: const Duration(milliseconds: 1500));
      int statusCode = await forgotPass(_emailTextField);
      await Future.delayed(const Duration(seconds: 1));
      _gifController.stop();
      setState(() {
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }
      if (statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Check your mail, you received a reset password link.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (statusCode == 404) {
        String emailExistsMsg = "That email doesn't exist. Please try again.";
        Consts.alertPopup(context, emailExistsMsg);
      } else {
        Consts.alertPopup(
            context, "Couldn't connect to server. Please try again.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: buildCustomLoadingWidget(_gifController),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 130, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/reset-password.png',
                  fit: BoxFit.fitWidth,
                ),
                const Text(
                  'Forgot\nPassword',
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 30,
                ),
                LoginTextField(
                  textHint: 'Enter email',
                  icon: Icons.person,
                  onChanged: _updateUsernameFieldValue,
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: onForgotPass,
                  child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Consts.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      margin: const EdgeInsets.all(5.0),
                      child: const Center(
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const Login(),
                            type: PageTransitionType.bottomToTop));
                  },
                  child: Center(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: "Have an account? ",
                        style: TextStyle(
                          color: Consts.lessBlack,
                        ),
                      ),
                      TextSpan(
                        text: ' Login here!',
                        style: TextStyle(
                          color: Consts.primaryColor,
                        ),
                      ),
                    ])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
