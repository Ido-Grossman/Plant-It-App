import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:frontend/widgets/plant_loading_icon.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';

import '../constants.dart';
import '../service/http_service.dart';
import '../service/login_text_field.dart';
import '../widgets/normal_button.dart';
import 'login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
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
      _gifController.repeat(
          min: 0, max: 29, period: const Duration(milliseconds: 1500));
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
        Consts.alertPopup(context, Consts.cantConnect);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    Color textColor = currentTheme.textTheme.bodyLarge!.color!;
    Color linkColor = currentTheme.brightness == Brightness.light
        ? Consts.primaryColor
        : Consts.greenDark;
    Size size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: getPlantLoadingIcon(_gifController),
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
                NormalButton(
                    size: size,
                    onPress: onForgotPass,
                    isEnabled: true,
                    buttonText: 'Reset Password'),
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
                          color: textColor,
                        ),
                      ),
                      TextSpan(
                        text: ' Login here!',
                        style: TextStyle(
                          color: linkColor,
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
