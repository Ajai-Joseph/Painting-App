import 'package:get/get.dart';
import 'package:paint_the_drawing/controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PaintingController());
  }
}
