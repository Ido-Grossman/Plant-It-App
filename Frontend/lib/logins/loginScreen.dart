import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/home/homeScreen.dart';
import 'package:frontend/logins/forgotPasswordScreen.dart';
import 'package:frontend/logins/googleLoginScreen.dart';
import 'package:frontend/logins/signUpScreen.dart';
import 'package:frontend/service/googleSignIn.dart';
import 'package:frontend/service/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../service/httpService.dart';
import '../service/loginTextField.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  String _mailTextField = '';
  String _passwordTextField = '';
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

  void _updateMailFieldValue(String value) {
    setState(() {
      _mailTextField = value;
    });
  }


  void _updatePasswordFieldValue(String value) {
    setState(() {
      _passwordTextField = value;
    });
  }

  Future<void> onLogin() async {
    if (_mailTextField.isNotEmpty &&
        _passwordTextField.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      _gifController.repeat(min: 0, max: 29, period: const Duration(milliseconds: 1500));
      String? token =
          await logIn(_mailTextField, _passwordTextField);
      await Future.delayed(const Duration(seconds: 1));
      _gifController.stop();
      setState(() {
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }
      if (token != 'error' && token != null) {
        Navigator.push(
            context,
            PageTransition(
                child: FirstScreen(
                  username: _mailTextField,
                  token: token,
                ),
                type: PageTransitionType.bottomToTop));
      } else if (token == 'error') {
        String badCredentialsMsg =
            'Incorrect email or password';
        Consts.alertPopup(context, badCredentialsMsg);
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
        ? Consts.primaryColor : Consts.greenDark;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String? email = snapshot.data?.email;
              String uid = snapshot.data!.uid;
              return GoogleLoginPage(email: email, uid: uid,);
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            } else {
              return ModalProgressHUD(
                inAsyncCall: _isLoading,
                progressIndicator: buildCustomLoadingWidget(_gifController),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/login.png',
                          fit: BoxFit.fill,
                        ),
                        const Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 35.0, fontWeight: FontWeight.w700),
                        ),
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
                          onTap: onLogin,
                          child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                color: (_mailTextField.isNotEmpty &&
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
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: const ForgotPasswordScreen(),
                                    type: PageTransitionType.bottomToTop));
                          },
                          child: Center(
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: 'Forgot Password? ',
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                              TextSpan(
                                text: ' Reset Password',
                                style: TextStyle(
                                  color: linkColor,
                                ),
                              ),
                            ])),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            Expanded(
                                child: Divider(
                              thickness: 2,
                            )),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('OR'),
                            ),
                            Expanded(
                                child: Divider(
                              thickness: 2,
                            )),
                          ],
                        ),
                        Container(
                            width: size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: SignInButton(
                              Buttons.Google,
                              onPressed: () {
                                final provider =
                                    Provider.of<GoogleSignInProvider>(context,
                                        listen: false);
                                provider.googleLogin();
                              },
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: const SignUp(),
                                    type: PageTransitionType.bottomToTop));
                          },
                          child: Center(
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                              TextSpan(
                                text: ' Register here!',
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
              );
            }
          }),
    );
  }
}
