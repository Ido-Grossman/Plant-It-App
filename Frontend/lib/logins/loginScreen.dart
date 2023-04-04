import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/home/homeScreen.dart';
import 'package:frontend/logins/forgotPasswordScreen.dart';
import 'package:frontend/logins/signUpScreen.dart';
import 'package:frontend/service/googleSignIn.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../service/loginTextField.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _mailTextField = '';
  String _passwordTextField = '';

  void _updateMailFieldValue(String value){
    setState(() {
      _mailTextField = value;
    });
  }

  void _updatePasswordFieldValue(String value){
    setState(() {
      _passwordTextField = value;
    });
  }


  Future<int> _logIn(String email, String password) async {
    final url = Uri.parse('${Consts.prefixLink}api/accounts/login/');
    try {
      final response = await http.post(url,
          body: {'email': email, 'password': password}).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode;
    } on TimeoutException {
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
           if (snapshot.hasData) {
            return const FirstScreen();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'),);
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/login.png', fit: BoxFit.fill,),
                    const Text('Log In',
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.w700
                      ),),
                    const SizedBox(
                      height: 30,
                    ),
                    LoginTextField(
                      textHint: 'Enter Email',
                      icon: Icons.alternate_email,
                      onChanged: _updateMailFieldValue,
                      isEmail: true,
                    ),
                    LoginTextField(
                      textHint: 'Enter Password',
                      icon: Icons.password,
                      onChanged: _updatePasswordFieldValue,
                      hideText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_mailTextField.isNotEmpty && _passwordTextField.isNotEmpty){
                          int statusCode = await _logIn(_mailTextField, _passwordTextField);
                          if (!mounted) {
                            return;
                          }
                          if(statusCode == 200){
                            Navigator.push(context, PageTransition(
                                child: FirstScreen(username: _mailTextField,),
                                type: PageTransitionType.bottomToTop));
                          } else if (statusCode == 401) {
                            String badCredentialsMsg = 'Incorrect email or password';
                            Consts.alertPopup(context, badCredentialsMsg);
                          } else {
                            String badConnectionMsg = 'Connection refused or bad request. Please try again.';
                            Consts.alertPopup(context, badConnectionMsg);
                          }
                        }
                      },
                      child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: (_mailTextField.isNotEmpty && _passwordTextField.isNotEmpty) ? Consts.primaryColor : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          margin: const EdgeInsets.all(5.0),
                          child: const Center(
                            child: Text('Login In', style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),),
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageTransition(
                            child: const ForgotPasswordScreen(),
                            type: PageTransitionType.bottomToTop));
                      },
                      child: Center(
                        child: Text.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Forgot Password? ',
                                    style: TextStyle(
                                      color: Consts.lessBlack,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Reset Password',
                                    style: TextStyle(
                                      color: Consts.primaryColor,
                                    ),
                                  ),
                                ]
                            )
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Expanded(child: Divider(
                          thickness: 2,
                        )),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('OR'),),
                        Expanded(child: Divider(
                          thickness: 2,
                        )),
                      ],
                    ),
                    Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: SignInButton(
                          Buttons.Google,
                          onPressed: () {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context, listen: false
                            );
                            provider.googleLogin();
                          },
                        )
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageTransition(
                            child: const SignUp(),
                            type: PageTransitionType.bottomToTop));
                      },
                      child: Center(
                        child: Text.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                      color: Consts.lessBlack,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Register here!',
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
            );
          }
        }
      ),
    );
  }
}


