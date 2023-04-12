import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:provider/provider.dart';

import '../main.dart';

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