import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../home/homeScreen.dart';
import '../service/loginTextField.dart';
import 'loginScreen.dart';

class ChooseUsernameScreen extends StatefulWidget {
  final String email;
  const ChooseUsernameScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ChooseUsernameScreen> createState() => _ChooseUsernameScreenState();
}

class _ChooseUsernameScreenState extends State<ChooseUsernameScreen> {
  String _usernameTextField = '';

  _updateUsernameFieldValue(String value) {
    setState(() {
      _usernameTextField = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<int> _chooseUsername(String username) async {
      final url = Uri.parse('${Consts.prefixLink}api/accounts/set-username/');
      try {
        final response = await http.post(url,
            body: {'username': username, 'email': widget.email}).timeout(
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
              const Text('Choose your\nusername',
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w700
                ),),
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
                onTap: () async {
                  if (_usernameTextField.isNotEmpty) {
                    int statusCode = await _chooseUsername(_usernameTextField);
                    if (!mounted) {
                      return;
                    }
                    if(statusCode == 200){
                      Navigator.push(context, PageTransition(
                          child: FirstScreen(username: _usernameTextField,),
                          type: PageTransitionType.bottomToTop));
                    } else if (statusCode == 409) {
                      String emailExistsMsg = "That username already exists. Please enter another one.";
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
                      child: Text('I chose one!', style:
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
