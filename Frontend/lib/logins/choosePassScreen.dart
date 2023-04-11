import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:frontend/logins/chooseUsernameScreen.dart';
import 'package:frontend/service/httpService.dart';
import 'package:frontend/service/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';

import '../constants.dart';
import '../service/passwordValidationFields.dart';

class ChoosePassScreen extends StatefulWidget {

  const ChoosePassScreen({Key? key}) : super(key: key);

  @override
  State<ChoosePassScreen> createState() => _ChoosePassScreenState();
}

class _ChoosePassScreenState extends State<ChoosePassScreen> with TickerProviderStateMixin {
  bool _isButtonEnabled = false;
  String _passwordTextField = '';
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  void _onValidationChanged(bool isEnabled) {
    setState(() {
      _isButtonEnabled = isEnabled;
    });
  }

  void _updatePasswordFieldValue(String value) {
    setState(() {
      _passwordTextField = value;
    });
  }

  Future<void> onSetPassword() async {
    if (_isButtonEnabled && _passwordTextField.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      _gifController.repeat(min: 0, max: 29, period: const Duration(milliseconds: 1500));
      int statusCode = await signUpGoogle(user!.email, user!.uid, _passwordTextField);
      await Future.delayed(const Duration(seconds: 1));
      _gifController.stop();
      setState(() {
        _isLoading = false;
      });
      if (statusCode == 201) {
        String? token = await logInGoogle(user!.email, user!.uid);
        if (!mounted) {
          return;
        }
          Navigator.push(
              context,
              PageTransition(
                  child: ChooseUsernameScreen(token: token,),
                  type: PageTransitionType.bottomToTop));
        } else if (statusCode == 404) {
        Consts.alertPopup(context, 'The password is not strong enough, please try another one');
      } else {
        Consts.alertPopup(context, Consts.cantConnect);
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
                  'Choose your\npassword',
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 30,
                ),
                PasswordValidationForms(
                  onValidationChanged: _onValidationChanged,
                  onPassChange: _updatePasswordFieldValue,
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: onSetPassword,
                  child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: (_isButtonEnabled &&
                            _passwordTextField.isNotEmpty)
                            ? Consts.primaryColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      margin: const EdgeInsets.all(5.0),
                      child: const Center(
                        child: Text(
                          'I chose one!',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
