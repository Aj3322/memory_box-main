import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hackharvard21/Databases/MemoryDatabase.dart';
import 'package:hackharvard21/Models/Task.dart';
import 'package:hackharvard21/Models/Vedio.dart';
import 'package:uuid/uuid.dart';

import '../Models/Medicine.dart';
class RoutineController extends GetxController{
  RxList<Task> completedTask = <Task>[].obs;
  RxList<Task> totalTask = <Task>[].obs;
  RxList<Task> missedTask = <Task>[].obs;
  RxList<Task> pendingTask =<Task>[].obs;
  RxList<Medication> medicine =<Medication>[].obs;
  RxList<Memory> memoryV =<Memory>[].obs;

  RxBool status = false.obs;


  Future<void> addTask(Task task) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('tasks');
      final docRef = await collectionRef.add(task.toMap());
      task.id = docRef.id;
      pendingTask.add(task);
    } catch (error) {
      print('Error adding task: $error');
    }
  }
  Future<void> deleteTask(Task task) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('tasks');
      await collectionRef.doc(task.id).delete();

      completedTask.remove(task);
      totalTask.remove(task);
      missedTask.remove(task);
      pendingTask.remove(task);
    } catch (error) {
      print('Error deleting task: $error');
      // Handle error appropriately
    }
  }
  Future<void> fetchTasks() async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('tasks');
      final snapshot = await collectionRef.get();

      final tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
      completedTask.assignAll(tasks.where((task) => task.completed));
      totalTask.assignAll(tasks); // Assign all tasks to totalTask
      missedTask.assignAll(tasks.where((task) => task.missed));
      pendingTask.assignAll(tasks.where((task) => !task.completed && !task.missed));
    } catch (error) {
      print('Error fetching tasks: $error');
      // Handle error appropriately
    }
  }
  Future<void> updateTask(Task updatedTask) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('tasks');
      await collectionRef.doc(updatedTask.id).update(updatedTask.toMap());

      if (updatedTask.completed) {
        completedTask.add(updatedTask);
        pendingTask.remove(updatedTask);
      } else {
        completedTask.remove(updatedTask);
        pendingTask.add(updatedTask);
      }

      // Consider notifying UI listeners about changes

    } catch (error) {
      print('Error updating task: $error');
      // Handle error appropriately
    }
  }

  Future<void> addMedication(Medication medication) async {
    print("hello");
    try {
      final collectionRef = FirebaseFirestore.instance.collection('medications');
      await collectionRef.add(medication.toMap());
    } catch (error) {
      // Handle errors gracefully, e.g., log or show error message
      print('Error adding medication to Firestore: $error');
    }
  }
  Future<void> fetchMedicalData() async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('medications');
      final querySnapshot = await collectionRef.get();

      // Check for errors or empty results
      if (querySnapshot.docs.isEmpty) {
        print('No medical data found in Firestore.');
      }

      // Convert documents to Medication objects
      final medicationList = querySnapshot.docs
          .map((doc) => Medication.fromMap(doc.data()))
          .toList();

     medicine.value= medicationList;
    } catch (error) {
      print('Error fetching medical data: $error');
    }
  }
  Future<void> deleteMedicalDataById(String medicationId) async {
    status.value = true;
    try {
      final collectionRef = FirebaseFirestore.instance.collection('medications');

      // Use a proper query to find the document with the given ID
      QuerySnapshot querySnapshot = await collectionRef
          .where('id', isEqualTo: medicationId)
          .get(); // Get matching documents

      if (querySnapshot.docs.isNotEmpty) {
        // Document found, proceed with deletion
        await querySnapshot.docs.first.reference.delete();
        print("Deleting: Completed");

        fetchMedicalData();
        print("Fetching data: Completed");
        status.value = false;
      } else {
        print("No document found with ID: $medicationId");
        status.value = false;
      }
    } catch (error) {
      // Handle errors gracefully, e.g., log or show error message
      print('Error deleting medical data: $error');
      status.value = false;
    }
  }

  void fethVedio() async{
    memoryV.value = await MemoriesDatabase.instance.readAllVideoMemories();
    print(memoryV.first);
  }


  @override
  void onInit() {
   fetchTasks();
   fetchMedicalData();
   fethVedio();
    super.onInit();
  }


}