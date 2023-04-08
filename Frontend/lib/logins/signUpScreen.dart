import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:frontend/logins/chooseUsernameScreen.dart';
import 'package:frontend/logins/loginScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../service/googleSignIn.dart';
import '../service/httpService.dart';
import '../service/loginTextField.dart';
import '../service/passwordValidationFields.dart';
import 'googleLoginScreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isButtonEnabled = false;
  String _mailTextField = '';
  String _passwordTextField = '';

  void _onValidationChanged(bool isEnabled) {
    setState(() {
      _isButtonEnabled = isEnabled;
    });
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

  Future<void> onSignUp() async {
    if (_isButtonEnabled && _mailTextField.isNotEmpty) {
      int statusCode = await signUp(_mailTextField, _passwordTextField);
      if (!mounted) {
        return;
      }
      if (statusCode == 201) {
        Navigator.push(
            context,
            PageTransition(
                child: ChooseUsernameScreen(
                  email: _mailTextField,
                ),
                type: PageTransitionType.bottomToTop));
      } else if (statusCode == 400) {
        String emailExistsMsg = 'The email already exists. Please try again.';
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

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String? email = snapshot.data?.email;
              String uid = snapshot.data!.uid;
              return GoogleLoginPage(
                email: email,
                uid: uid,
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            } else {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/signup.png',
                        fit: BoxFit.fitWidth,
                      ),
                      const Text(
                        'Sign Up',
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
                      PasswordValidationForms(
                        onValidationChanged: _onValidationChanged,
                        onPassChange: _updatePasswordFieldValue,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: onSignUp,
                        child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              color: (_isButtonEnabled &&
                                      _mailTextField.isNotEmpty)
                                  ? Consts.primaryColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            margin: const EdgeInsets.all(5.0),
                            child: const Center(
                              child: Text(
                                'Sign Up',
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
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.googleLogin();
                          },
                        ),
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
              );
            }
          }),
    );
  }
}


