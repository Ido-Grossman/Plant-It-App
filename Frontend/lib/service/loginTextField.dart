import 'package:flutter/material.dart';

import '../constants.dart';

class LoginTextField extends StatefulWidget {
  final IconData icon;
  final String textHint;
  final Function(String) onChanged;

  const LoginTextField({
    super.key, required this.icon, required this.textHint, required this.onChanged,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      onChanged: widget.onChanged,
      obscureText: false,
      style: TextStyle(
        color: Consts.lessBlack,
      ),
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(widget.icon, color: Consts.lessBlack.withOpacity(.3),),
          hintText: widget.textHint
      ),
      cursorColor: Consts.lessBlack.withOpacity(.5),
    );
  }
}