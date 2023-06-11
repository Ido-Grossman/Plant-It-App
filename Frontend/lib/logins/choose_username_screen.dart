import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:frontend/service/http_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';

import '../constants.dart';
import '../home/main_screen.dart';
import '../service/login_text_field.dart';
import '../widgets/plant_loading_icon.dart';

class ChooseUsernameScreen extends StatefulWidget {
  final String? token;
  final String email;

  const ChooseUsernameScreen({Key? key, required this.token, required this.email}) : super(key: key);

  @override
  State<ChooseUsernameScreen> createState() => _ChooseUsernameScreenState();
}

class _ChooseUsernameScreenState extends State<ChooseUsernameScreen>
    with TickerProviderStateMixin {
  String _usernameTextField = '';
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

  _updateUsernameFieldValue(String value) {
    setState(() {
      _usernameTextField = value;
    });
  }

  Future<void> onSetUsername() async {
    if (_usernameTextField.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      _gifController.repeat(
          min: 0, max: 29, period: const Duration(milliseconds: 1500));
      int statusCode = await chooseUsername(_usernameTextField, widget.token);
      await Future.delayed(const Duration(seconds: 1));
      _gifController.stop();
      setState(() {
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }
      if (statusCode == 200) {
        if (user != null) {
          Navigator.push(
              context,
              PageTransition(
                  child: MainScreen(
                    token: widget.token,
                    email: user!.email!,
                  ),
                  type: PageTransitionType.bottomToTop));
        } else {
          Navigator.push(
              context,
              PageTransition(
                  child: MainScreen(
                    username: _usernameTextField,
                    token: widget.token,
                    email: widget.email,
                  ),
                  type: PageTransitionType.bottomToTop));
        }
      } else if (statusCode == 409) {
        String usernameExistsMsg =
            "That username already exists. Please enter another one.";
        Consts.alertPopup(context, usernameExistsMsg);
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
                  'Choose your\nusername',
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 30,
                ),
                LoginTextField(
                  textHint: 'Please choose a username',
                  icon: Icons.person,
                  onChanged: _updateUsernameFieldValue,
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: onSetUsername,
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
