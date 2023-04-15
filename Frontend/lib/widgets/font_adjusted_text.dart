import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class FontAdjustedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const FontAdjustedText({Key? key, required this.text, this.style})
      : super(key: key);

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
