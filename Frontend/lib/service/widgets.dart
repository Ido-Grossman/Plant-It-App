import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../main.dart';
import 'googleSignIn.dart';

Widget buildCustomLoadingWidget(GifController gifController) {
  return GifImage(
    controller: gifController,
    image: const AssetImage('assets/plant-loading.gif'),
    height: 100,
    width: 100,
  );
}

class CustomFontText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CustomFontText({Key? key, required this.text, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FontSizeNotifier fontSizeNotifier = Provider.of<FontSizeNotifier>(context);

    return Text(
      text,
      style: (style ?? DefaultTextStyle.of(context).style).copyWith(
        fontSize: fontSizeNotifier.fontSize,
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const CustomIcon({Key? key, required this.icon, this.size, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FontSizeNotifier fontSizeNotifier = Provider.of<FontSizeNotifier>(context);
    return Icon(
      icon,
      size: size ?? fontSizeNotifier.fontSize,
      color: color,
    );
  }
}

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
          backgroundColor: Consts.primaryColor, // Set the background color to green
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Add rounded corners
          ),
          padding: const EdgeInsets.all(14), // Set padding for the button
        ),
        onPressed: () {
          final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
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
            const SizedBox(width: 8), // Add some space between the logo and the text
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

class NormalSignButton extends StatelessWidget {
  const NormalSignButton({
    Key? key,
    required this.size,
    required this.onLogin,
    required this.isEnabled,
    required this.buttonText,
  }) : super(key: key);

  final Size size;
  final VoidCallback onLogin;
  final bool isEnabled;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onLogin : null,
      child: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: isEnabled ? Consts.primaryColor : Colors.grey,
          borderRadius: BorderRadius.circular(30), // Add rounded corners
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
