import 'package:flutter/material.dart';

import '../constants.dart';

class LoginTextField extends StatefulWidget {
  final IconData icon;
  final String textHint;
  final Function(String) onChanged;
  final bool hideText;
  final bool isEmail;

  const LoginTextField({
    super.key, required this.icon, required this.textHint, required this.onChanged, this.isEmail = false, this.hideText = false,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  String? _emailError;

  void _validateEmail(){
    if (widget.isEmail &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_textEditingController.text)) {
      _emailError = 'Please enter a correct email';
    } else {
      _emailError = null;
    }
  }

  @override
  void initState() {
    super.initState();

    // Listen for changes in the password fields and update the validation message
    _textEditingController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textEditingController,
      onChanged: widget.onChanged,
      obscureText: widget.hideText,
      style: TextStyle(
        color: Consts.lessBlack,
      ),
      decoration: InputDecoration(
          border: InputBorder.none,
          errorText: _emailError,
          prefixIcon: Icon(widget.icon, color: Consts.lessBlack.withOpacity(.3),),
          hintText: widget.textHint
      ),
      cursorColor: Consts.lessBlack.withOpacity(.5),
    );
  }
}