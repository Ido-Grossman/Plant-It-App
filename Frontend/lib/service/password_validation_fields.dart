import 'package:flutter/material.dart';

class PasswordValidationForms extends StatefulWidget {
  final Function(bool) onValidationChanged;
  final Function(String) onPassChange;

  const PasswordValidationForms(
      {Key? key, required this.onValidationChanged, required this.onPassChange})
      : super(key: key);

  @override
  PasswordValidationFormsState createState() => PasswordValidationFormsState();
}

class PasswordValidationFormsState extends State<PasswordValidationForms> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _passwordError;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();

    // Listen for changes in the password fields and update the validation message
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _passwordError = "Passwords do not match";
        _isButtonDisabled = true;
      });
    } else if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _isButtonDisabled = true;
    } else {
      setState(() {
        _passwordError = null;
        _isButtonDisabled = false;
      });
    }
    widget.onValidationChanged(!_isButtonDisabled);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    Color textColor = currentTheme.textTheme.bodyLarge!.color!;
    Color cursorColor = textColor.withOpacity(.5);
    Color iconColor = textColor.withOpacity(.3);

    return Column(
      children: [
        TextFormField(
          style: TextStyle(
            color: textColor,
          ),
          controller: _passwordController,
          onChanged: widget.onPassChange,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.password,
                color: iconColor,
              ),
              hintText: 'Enter your password'),
          obscureText: true,
          cursorColor: cursorColor,
        ),
        TextFormField(
          style: TextStyle(
            color: textColor,
          ),
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.password,
              color: iconColor,
            ),
            hintText: 'Enter your password again',
            errorText: _passwordError,
          ),
          obscureText: true,
          cursorColor: cursorColor,
        ),
      ],
    );
  }
}
