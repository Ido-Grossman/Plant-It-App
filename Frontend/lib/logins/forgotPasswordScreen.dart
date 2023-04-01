import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../home/homeScreen.dart';
import '../service/loginTextField.dart';
import 'loginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _usernameTextField = '';

  _updateUsernameFieldValue(String value) {
    setState(() {
      _usernameTextField = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<int> _forgotPass(String username) async {
      final url = Uri.parse('${Consts.prefixLink}api/accounts/forgot-password/');
      try {
        final response = await http.post(url,
            body: {'email': username}).timeout(
          const Duration(seconds: 10),
        );
        return response.statusCode;
      } on TimeoutException {
        return -1;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 130, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/reset-password.png', fit: BoxFit.fitWidth,),
              const Text('Forgot\nPassword',
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w700
                ),),
              const SizedBox(
                height: 30,
              ),
              LoginTextField(
                textHint: 'Enter username',
                icon: Icons.person,
                onChanged: _updateUsernameFieldValue,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  if (_usernameTextField.isNotEmpty) {
                    int statusCode = await _forgotPass(_usernameTextField);
                    if (!mounted) {
                      return;
                    }
                    if(statusCode == 200){
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
                      String emailExistsMsg = "That doesn't username exists. Please try again.";
                      Consts.alertPopup(context, emailExistsMsg);
                    } else {
                      Consts.alertPopup(context, "Couldn't connect to server. Please try again.");
                    }}
                  },
                child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Consts.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    margin: const EdgeInsets.all(5.0),
                    child: const Center(
                      child: Text('Reset Password', style:
                      TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),),
                    )
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(
                      child: const Login(),
                      type: PageTransitionType.bottomToTop));
                },
                child: Center(
                  child: Text.rich(
                      TextSpan(
                          children: [
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
                          ]
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
