import 'package:flutter/material.dart';
import 'package:frontend/logins/loginScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../home/homeScreen.dart';
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
  String _passwordTextField = '';

  void _onValidationChanged(bool isEnabled){
    setState(() {
      _isButtonEnabled = isEnabled;
    });
  }

  Future<int> _signUp(String username, String password, String email) async {
    final url = Uri.parse('${Consts.prefixLink}api/accounts/register/');
    final response = await http.post(url,
        body: {'username': username, 'password': password, 'email': email});
    return response.statusCode;
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

  void _updatePasswordFieldValue(String value){
    setState(() {
      _passwordTextField = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
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
                textHint: 'Enter Email',
                icon: Icons.alternate_email,
                onChanged: _updateMailFieldValue,
                isEmail: true,
              ),
              LoginTextField(
                textHint: 'Enter Username',
                icon: Icons.supervised_user_circle,
                onChanged: _updateUsernameFieldValue,
              ),
              PasswordValidationForms(
                onValidationChanged: _onValidationChanged,
                onPassChange: _updatePasswordFieldValue,),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  if (_isButtonEnabled && _mailTextField.isNotEmpty && _usernameTextField.isNotEmpty) {
                    int statusCode = await _signUp(_usernameTextField, _passwordTextField, _mailTextField);
                    if (!mounted) {
                      return;
                    }
                    if(statusCode == 201){
                      Navigator.push(context, PageTransition(
                          child: const FirstScreen(),
                          type: PageTransitionType.bottomToTop));
                    } else {
                      showDialog(context: context,
                          builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('The user already exists, please try again.'),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.of(context).pop();
                            },
                                child: const Text('Ok'))
                          ],
                        );
                          });}}},

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


