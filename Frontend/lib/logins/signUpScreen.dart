import 'package:flutter/material.dart';
import 'package:frontend/logins/loginScreen.dart';
import 'package:page_transition/page_transition.dart';

import '../constants.dart';
import '../service/loginTextField.dart';
import '../service/passwordValidationFields.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isButtonEnabled = false;
  String _mailTextField = '';
  String _usernameTextField = '';

  void _onValidationChanged(bool isEnabled){
    setState(() {
      _isButtonEnabled = isEnabled;
    });
  }

  void _updateMailFieldValue(String value){
    setState(() {
      _mailTextField = value;
    });
  }

  void _updateUsernameFieldValue(String value){
    setState(() {
      _usernameTextField = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/signup.png', fit: BoxFit.fitWidth,),
              const Text('Sign Up',
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w700
                ),),
              const SizedBox(
                height: 30,
              ),
              LoginTextField(
                textHint: 'Enter Mail',
                icon: Icons.alternate_email,
                onChanged: _updateMailFieldValue,
              ),
              LoginTextField(
                textHint: 'Enter Username',
                icon: Icons.supervised_user_circle,
                onChanged: _updateUsernameFieldValue,
              ),
              PasswordValidationForms(onValidationChanged: _onValidationChanged,),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (_isButtonEnabled && _mailTextField.isNotEmpty && _usernameTextField.isNotEmpty) {
                    print('hey');
                  } else {
                    null;
                  }},
                  // Navigator.push(context, PageTransition(
                  //     child: const FirstScreen(),
                  //     type: PageTransitionType.bottomToTop));,
                  child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                  color: (_isButtonEnabled && _mailTextField.isNotEmpty && _usernameTextField.isNotEmpty) ? Consts.primaryColor : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  margin: EdgeInsets.all(5.0),
                  child: const Center(
                  child: Text('Sign Up', style:
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
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Consts.primaryColor),
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Image.asset('assets/google.png'),
                    ),
                    Text('Sign Up through Google', style: TextStyle(
                        color: Consts.lessBlack,
                        fontSize: 18.0
                    ),)
                  ],
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

