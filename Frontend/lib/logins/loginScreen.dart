import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/home/homeScreen.dart';
import 'package:page_transition/page_transition.dart';

import '../service/loginTextField.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/signin.png', fit: BoxFit.fitWidth,),
            const Text('Sign In',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w700
              ),),
            const SizedBox(
              height: 30,
            ),
            const LoginTextField(
              obsText: false,
              textHint: 'Enter Mail',
              icon: Icons.alternate_email,
            ),
            const LoginTextField(
              obsText: true,
              textHint: 'Enter Password',
              icon: Icons.password,
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: (){
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
                  child: Text('Sign In', style: TextStyle(
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
                    child: const FirstScreen(),
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
                  Text('Sign In through Google', style: TextStyle(
                    color: Consts.lessBlack,
                    fontSize: 18.0
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


