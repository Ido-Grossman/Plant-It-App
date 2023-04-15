import 'package:flutter/material.dart';

import '../constants.dart';

class NormalButton extends StatelessWidget {
  const NormalButton({
    Key? key,
    required this.size,
    required this.onPress,
    required this.isEnabled,
    required this.buttonText,
  }) : super(key: key);

  final Size size;
  final VoidCallback onPress;
  final bool isEnabled;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPress : null,
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
