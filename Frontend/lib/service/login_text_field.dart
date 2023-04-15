import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final IconData icon;
  final String textHint;
  final Function(String) onChanged;
  final bool hideText;
  final bool isEmail;

  const LoginTextField({
    super.key,
    required this.icon,
    required this.textHint,
    required this.onChanged,
    this.isEmail = false,
    this.hideText = false,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  String? _emailError;

  void _validateEmail() {
    if (widget.isEmail &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_textEditingController.text)) {
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
    ThemeData currentTheme = Theme.of(context);
    Color textColor = currentTheme.textTheme.bodyLarge!.color!;
    Color cursorColor = textColor.withOpacity(.5);
    Color iconColor = textColor.withOpacity(.3);

    return TextFormField(
      controller: _textEditingController,
      onChanged: widget.onChanged,
      obscureText: widget.hideText,
      style: TextStyle(
        color: textColor,
      ),
      decoration: InputDecoration(
          border: InputBorder.none,
          errorText: _emailError,
          prefixIcon: Icon(
            widget.icon,
            color: iconColor,
          ),
          hintText: widget.textHint),
      cursorColor: cursorColor,
    );
  }
}
