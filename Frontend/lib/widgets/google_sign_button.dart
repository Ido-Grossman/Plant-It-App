import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../service/google_sign_in.dart';

class GoogleSignButton extends StatelessWidget {
  const GoogleSignButton({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Consts.primaryColor,
          // Set the background color to green
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Add rounded corners
          ),
          padding: const EdgeInsets.all(14), // Set padding for the button
        ),
        onPressed: () {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.googleLogin();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
                border: Border.all(color: Consts.primaryColor, width: 2),
              ),
              child: Image.network(
                'https://developers.google.com/identity/images/g-logo.png',
                height: 20.0, // Set the Google logo size
              ),
            ),
            const SizedBox(width: 8),
            // Add some space between the logo and the text
            const Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
