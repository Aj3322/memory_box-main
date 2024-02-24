import 'package:get/get.dart';
import 'package:hackharvard21/Controller/HomeController.dart';
import 'package:hackharvard21/Controller/RoutineController.dart';
class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => RoutineController());

  }

}