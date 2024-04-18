import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:get/get.dart';
import 'package:paint_the_drawing/controller.dart';
import 'package:vibration/vibration.dart';

List<Color> colorList = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.indigo,
  Colors.brown,
  Colors.grey,
  Colors.black,
  Colors.white,
  Colors.amber,
  Colors.deepOrange,
  Colors.lime,
  Colors.lightGreen,
  Colors.deepPurple,
  Colors.blueGrey,
];
List<double> brushWidthList = [1, 2, 3, 4, 5, 6];

class HomeScreen extends GetWidget<PaintingController> {
  HomeScreen({
    super.key,
  });

  // final path = parseSvgPathData('M239.7,260.2c0.5,0,1,0,1.6,0c0.2,0,0.4,0,0.6,0c0.3,0,0.7,0,1,0c29.3-0.5,53-10.8,70.5-30.5 c38.5-43.4,32.1-117.8,31.4-124.9c-2.5-53.3-27.7-78.8-48.5-90.7C280.8,5.2,262.7,0.4,242.5,0h-0.7c-0.1,0-0.3,0-0.4,0h-0.6 c-11.1,0-32.9,1.8-53.8,13.7c-21,11.9-46.6,37.4-49.1,91.1c-0.7,7.1-7.1,81.5,31.4,124.9C186.7,249.4,210.4,259.7,239.7,260.2z M164.6,107.3c0-0.3,0.1-0.6,0.1-0.8c3.3-71.7,54.2-79.4,76-79.4h0.4c0.2,0,0.5,0,0.8,0c27,0.6,72.9,11.6,76,79.4 c0,0.3,0,0.6,0.1,0.8c0.1,0.7,7.1,68.7-24.7,104.5c-12.6,14.2-29.4,21.2-51.5,21.4c-0.2,0-0.3,0-0.5,0l0,0c-0.2,0-0.3,0-0.5,0 c-22-0.2-38.9-7.2-51.4-21.4C157.7,176.2,164.5,107.9,164.6,107.3z M446.8,383.6c0-0.1,0-0.2,0-0.3c0-0.8-0.1-1.6-0.1-2.5c-0.6-19.8-1.9-66.1-45.3-80.9c-0.3-0.1-0.7-0.2-1-0.3 c-45.1-11.5-82.6-37.5-83-37.8c-6.1-4.3-14.5-2.8-18.8,3.3c-4.3,6.1-2.8,14.5,3.3,18.8c1.7,1.2,41.5,28.9,91.3,41.7 c23.3,8.3,25.9,33.2,26.6,56c0,0.9,0,1.7,0.1,2.5c0.1,9-0.5,22.9-2.1,30.9c-16.2,9.2-79.7,41-176.3,41 c-96.2,0-160.1-31.9-176.4-41.1c-1.6-8-2.3-21.9-2.1-30.9c0-0.8,0.1-1.6,0.1-2.5c0.7-22.8,3.3-47.7,26.6-56 c49.8-12.8,89.6-40.6,91.3-41.7c6.1-4.3,7.6-12.7,3.3-18.8c-4.3-6.1-12.7-7.6-18.8-3.3c-0.4,0.3-37.7,26.3-83,37.8 c-0.4,0.1-0.7,0.2-1,0.3c-43.4,14.9-44.7,61.2-45.3,80.9c0,0.9,0,1.7-0.1,2.5c0,0.1,0,0.2,0,0.3c-0.1,5.2-0.2,31.9,5.1,45.3 c1,2.6,2.8,4.8,5.2,6.3c3,2,74.9,47.8,195.2,47.8s192.2-45.9,195.2-47.8c2.3-1.5,4.2-3.7,5.2-6.3 C447,415.5,446.9,388.8,446.8,383.6z');

  //ValueNotifier<Map<Color, List<Offset>>> pointNotifier = ValueNotifier({});
  ValueNotifier<bool> showOutsideIndicatorNotifier = ValueNotifier(false);
  //ValueNotifier<Color> colorNotifier = ValueNotifier(Colors.white);

  late CustomPathPainter customPathPainter;

  //final AudioPlayer audioPlayer = AudioPlayer();

  Path path = Get.arguments['path'];
  bool isSand = Get.arguments['isSand'];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalPadding = (screenWidth - path.getBounds().width) / 2;
    double verticalPadding = (screenHeight - path.getBounds().height) / 2;

    return Scaffold(
        body: Stack(
      children: [
        ValueListenableBuilder<bool>(
            valueListenable: showOutsideIndicatorNotifier,
            builder: (context, showIndicator, _) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (details) {
                  showOutsideIndicatorNotifier.value = true;
                },
                onPanEnd: (details) {
                  showOutsideIndicatorNotifier.value = false;
                },
                onTapUp: (details) {
                  showOutsideIndicatorNotifier.value = false;
                },
                child: Container(
                  color: showIndicator
                      ? Colors.red
                      : isSand
                          ? Color.fromARGB(211, 218, 80, 30)
                          : Colors.black,
                ),
              );
            }),

        Padding(
          padding: const EdgeInsets.only(left: 40, top: 20, bottom: 20),
          child: Container(
            padding: EdgeInsets.all(15),
            width: 130,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Color paintValue = controller.colorNotifier;
                            Color paintValue = colorList[index];

                            controller.updateColor(paintValue);
                          },
                          child: GetBuilder<PaintingController>(builder: (_) {
                            return Container(
                              decoration:
                                  controller.colorNotifier == colorList[index]
                                      ? BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(.8),
                                            width: 5,
                                          ),
                                        )
                                      : null,
                              child: CircleAvatar(
                                backgroundColor: colorList[index],
                              ),
                            );
                          }),
                        );
                      },
                      itemCount: colorList.length),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                    onTap: () {
                      showPaletteColorDialog(context);
                    },
                    child: Image.asset(
                      "assets/images/palette-saturation.png",
                      height: 70,
                    )),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapUp: (details) {
              showOutsideIndicatorNotifier.value = false;
            },
            onTapDown: (details) {
              showOutsideIndicatorNotifier.value = false;
            },
            onPanUpdate: (position) async {
              if (customPathPainter.hitTest(Offset(
                  position.localPosition.dx, position.localPosition.dy))) {
                showOutsideIndicatorNotifier.value = false;
                if (controller.isVibrating == false) {
                  controller.isVibrating = true;

                  Vibration.vibrate(duration: 600000);
                } // playaudio();
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset offset = renderBox.globalToLocal(position.localPosition);
                Map<Color, List<Offset>> newMap = controller.pointNotifier;
                newMap.forEach((color, points) {
                  if (points.contains(offset)) {
                    points.remove(offset);
                  }
                });
                if (newMap.containsKey(controller.colorNotifier)) {
                  newMap[controller.colorNotifier]!.add(offset);
                } else {
                  newMap[controller.colorNotifier] = [offset];
                }
                print(newMap.toString());
                controller.updateList(newMap);
              } else {
                controller.isVibrating = false;

                Vibration.cancel();
                // audioPlayer.stop();

                showOutsideIndicatorNotifier.value = true;
              }
            },
            onPanEnd: (details) async {
              controller.isVibrating = false;

              Vibration.cancel();

              showOutsideIndicatorNotifier.value = false;

              // audioPlayer.stop();
              // pointNotifier.value = List.of(pointNotifier.value)..add(null);
            },
            child: GetBuilder<PaintingController>(builder: (_) {
              return CustomPaint(
                painter: customPathPainter =
                    CustomPathPainter(path: path, isSand: isSand),
                foregroundPainter: DrawingPainter(
                  pointsMap: controller.pointNotifier,
                  path: path,
                  isSand: isSand,
                ),
                child: Container(),
              );
            }),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 200, top: 40),
        //   child: Container(
        //     padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        //     width: 180,
        //     decoration: BoxDecoration(
        //         color: Colors.grey.withOpacity(0.8),
        //         borderRadius: BorderRadius.circular(20)),
        //     child: GridView.builder(
        //         shrinkWrap: true,
        //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 3,
        //           mainAxisSpacing: 10,
        //           crossAxisSpacing: 10,
        //         ),
        //         itemBuilder: (BuildContext context, int index) {
        //           return InkWell(
        //             onTap: () {
        //               // Color paintValue = controller.colorNotifier;
        //               Color paintValue = colorList[index];

        //               controller.updateColor(paintValue);
        //             },
        //             child: GetBuilder<PaintingController>(builder: (_) {
        //               return Container(
        //                 padding: EdgeInsets.all(5),
        //                 decoration: BoxDecoration(
        //                     color: Colors.white,
        //                     borderRadius: BorderRadius.circular(10)),
        //                 child: Divider(
        //                   thickness: brushWidthList[index] * 3,
        //                 ),
        //               );
        //             }),
        //           );
        //         },
        //         itemCount: brushWidthList.length),
        //   ),
        // ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              Icons.arrow_back,size: 25,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ));
  }

  // void playaudio() {
  //   audioPlayer.play(
  //     AssetSource("audio/drawing.mp3"),
  //   );
  // }

  showPaletteColorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Material(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: palletteColorWidget(),
                ))),
          ));
          // actions: [
          //   Center(
          //     child: ElevatedButton(
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //       },
          //       child: const Text(
          //         'Select color',
          //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ),
          // ],
        });
  }

  Widget palletteColorWidget() {
    return ColorPicker(
      initialPicker: Picker.paletteSaturation,
      pickerOrientation: PickerOrientation.portrait,
      color: controller.colorNotifier,
      onChanged: (value) {
        controller.updateColor(value);
      },
    );
  }
}

class CustomPathPainter extends CustomPainter {
  const CustomPathPainter({required this.path, required this.isSand});
  final Path path;
  final bool isSand;
  @override
  bool shouldRepaint(CustomPathPainter oldDelegate) => false;
  @override
  void paint(Canvas canvas, Size size) {
    // double scaleX = size.width / path.getBounds().width;
    // double scaleY = size.height / path.getBounds().height;
    // double scale = scaleX < scaleY ? scaleX : scaleY;
    // double offsetX = (size.width - path.getBounds().width * scale) / 2;
    // double offsetY = (size.height - path.getBounds().height * scale) / 2;
    // canvas.translate(offsetX, offsetY);
    // canvas.scale(scale, scale);

    canvas.drawPath(
      path,
      Paint()
        ..color = isSand ? Colors.black : Colors.white
        ..style = isSand ? PaintingStyle.fill : PaintingStyle.stroke,
    );
  }

  @override
  bool hitTest(Offset position) {
    return path.contains(position);
  }
}

class DrawingPainter extends CustomPainter {
  Map<Color, List<Offset>> pointsMap;
  Path path;
  bool isSand;
  double? width;
  DrawingPainter(
      {required this.pointsMap,
      required this.path,
      required this.isSand,
      this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 60
      ..strokeCap = StrokeCap.round;
    if (!isSand) {
      canvas.clipPath(path);
    }
    List<Color> paintList = pointsMap.keys.toList();
    List<List<Offset>> pointList = pointsMap.values.toList();

    for (int i = 0; i < paintList.length; i++) {
      paint.color = paintList[i];
      canvas.drawPoints(PointMode.points, pointList[i], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
