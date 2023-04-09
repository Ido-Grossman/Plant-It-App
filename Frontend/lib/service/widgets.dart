import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

Widget buildCustomLoadingWidget(GifController gifController) {
  return GifImage(
    controller: gifController,
    image: const AssetImage('assets/plant-loading.gif'),
    height: 100,
    width: 100,
  );
}