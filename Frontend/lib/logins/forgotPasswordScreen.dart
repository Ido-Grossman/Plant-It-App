import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../constants.dart';
import '../home/homeScreen.dart';
import '../service/loginTextField.dart';
import 'loginScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                textHint: 'Enter Email',
                icon: Icons.alternate_email,
                onChanged: _updateMailFieldValue,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, PageTransition(
                      child: const FirstScreen(),
                      type: PageTransitionType.bottomToTop));
                  },
                child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Consts.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    margin: EdgeInsets.all(5.0),
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

  _updateMailFieldValue(String p1) {
  }

  _updateUsernameFieldValue(String p1) {
  }
}
