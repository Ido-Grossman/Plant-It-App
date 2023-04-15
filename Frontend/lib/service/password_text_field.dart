import 'package:flutter/material.dart';

import '../constants.dart';

class PasswordTextField extends StatefulWidget {
  final IconData icon;
  final String textHint;
  final formKey = GlobalKey<FormState>();

  PasswordTextField({
    super.key,
    required this.icon,
    required this.textHint,
  });

  @override
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      style: TextStyle(
        color: Consts.lessBlack,
      ),
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.icon,
            color: Consts.lessBlack.withOpacity(.3),
          ),
          hintText: widget.textHint),
      cursorColor: Consts.lessBlack.withOpacity(.5),
    );
  }
}
