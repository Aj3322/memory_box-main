import 'package:get/get.dart';
import 'package:hackharvard21/Models/Task.dart';
class LocationController extends GetxController{
  RxList<Task> completedTask = <Task>[].obs;
  RxList<Task> totalTask = <Task>[].obs;
  RxList<Task> missedTask = <Task>[].obs;
  RxList<Task> pendingTask =<Task>[].obs;


}