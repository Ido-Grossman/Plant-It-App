import 'package:flutter/material.dart';

import '../constants.dart';

class LoginTextField extends StatelessWidget {
  final IconData icon;
  final bool obsText;
  final String textHint;

  const LoginTextField({
    super.key, required this.icon, required this.obsText, required this.textHint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obsText,
      style: TextStyle(
        color: Consts.lessBlack,
      ),
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Consts.lessBlack.withOpacity(.3),),
          hintText: textHint
      ),
      cursorColor: Consts.lessBlack.withOpacity(.5),
    );
  }
}