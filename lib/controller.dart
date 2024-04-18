// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:paint_the_drawing/model.dart';

// class PaintingController extends GetxController {
//   List<CoordinateModel> pointList = [];
//   Color colorNotifier = Colors.white;
//   double width = 10;
//   void updateList(List<CoordinateModel> list) {
//     pointList = list;
//     update();
//   }

//   void updateColor(Color color) {
//     color = color;
//     update();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaintingController extends GetxController {
  Map<Color, List<Offset>> pointNotifier = {};
  bool isVibrating = false;

  Color colorNotifier = Colors.white;
  void updateList(Map<Color, List<Offset>> list) {
    pointNotifier = list;
    update();
  }

  void updateColor(Color color) {
    colorNotifier = color;
    update();
  }
}
