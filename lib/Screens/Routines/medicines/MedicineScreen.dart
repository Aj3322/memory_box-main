import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackharvard21/Controller/RoutineController.dart';
import 'package:hackharvard21/styles/text.dart';
import 'package:uuid/uuid.dart';

import '../../../Models/Medicine.dart';

class MdicinePage extends GetView<RoutineController> {
  const MdicinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
          onPressed: () {
            showAddMedicationDialog(controller);
          },
          icon: Icon(Icons.medical_services_outlined),
          label: Text("Add Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Here are your pills,',
              style: textStyleBlack(FontWeight.w500, 25.0),
            ),
           Obx(() =>  Expanded(child: ListView.builder(
             itemCount: controller.medicine.length,
             itemBuilder: (context, index) {
               return div(context,controller.medicine[index]);
             },
           )))
          ],
        ),
      ),
    );
  }


  Widget div(context , Medication medication) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onDoubleTap: () {

        },
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           Obx(() => controller.status.value?CircularProgressIndicator():  Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(
                 medication.schedule,
                 style: textStyleBlack(FontWeight.w300, 20.0),
               ),
               IconButton(onPressed: (){
                 controller.deleteMedicalDataById(medication.id);
               }, icon: Icon(Icons.delete))
             ],
           ),),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.medical_services_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(medication.name),
                subtitle: Text('Take ${medication.dosage} tablet'),
              ),
              ListTile(
                leading: Icon(
                  Icons.water_sharp,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Water'),
                subtitle: Text('${medication.water} Glasses'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

void showAddMedicationDialog(RoutineController controller) {
  final medicationNameController = TextEditingController();
  final medicationDosageController = TextEditingController();
  final medicationUnitController = TextEditingController();
  final medicationScheduleController = TextEditingController();
  final medicationStartDateController = TextEditingController();
  final medicationEndDateController = TextEditingController();
  final medicationNotesController = TextEditingController();
  final medicationWaterController = TextEditingController();

  Get.dialog<void>(
    AlertDialog(
      title: Text('Add Medication'),
      content: SingleChildScrollView(
        child: Column(children: [
          TextField(
            controller: medicationNameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: medicationDosageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Dosage (No of Tablet)'),
          ),
          TextField(
            keyboardType: TextInputType.numberWithOptions(),
            controller: medicationWaterController,
            decoration: InputDecoration(labelText: 'Amount of Water'),
          ),
          TextField(
            controller: medicationScheduleController,
            onTap: () async {
              // Show time picker dialog
              TimeOfDay? pickedTime = await showTimePicker(
                context: Get.context!,
                initialTime: TimeOfDay.now(),
              );
        
              if (pickedTime != null) {
                // Format the time as needed
                String formattedTime = pickedTime.format(Get.context!);
                // Or:
                // String formattedTime = '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}'; // Custom formatting
        
                medicationScheduleController.text = formattedTime;
              }
            },
            decoration: InputDecoration(labelText: 'Schedule'),
          ),
          TextField(
            controller: medicationStartDateController,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                medicationStartDateController.text = pickedDate.toIso8601String();
              }
            },
            decoration: InputDecoration(labelText: 'Start Date'),
          ),
          TextField(
            controller: medicationEndDateController,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                medicationEndDateController.text = pickedDate.toIso8601String();
              }
            },
            decoration: InputDecoration(labelText: 'End Date (optional)'),
          ),
          TextField(
            controller: medicationNotesController,
            decoration: InputDecoration(labelText: 'Notes (optional)'),
          ),
        ]),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        TextButton(
            onPressed: () {
              // Get user input from controllers
              String name = medicationNameController.text;
              String dosage = medicationDosageController.text;
              String unit = medicationUnitController.text;
              String schedule = medicationScheduleController.text;
              DateTime startDate =
                  DateTime.parse(medicationStartDateController.text);
              DateTime? endDate = medicationEndDateController.text.isNotEmpty
                  ? DateTime.parse(medicationEndDateController.text)
                  : null;
              String? notes = medicationNotesController.text;
              String water = medicationWaterController.text;

              final uid = Uuid().v4();
              // Create a Medication object
              Medication medication = Medication(
                  name: name,
                  dosage: dosage,
                  unit: unit,
                  schedule: schedule,
                  startDate: startDate,
                  endDate: endDate,
                  notes: notes,
                  id: uid,
                  water: water);

              controller.addMedication(medication).then((value) => controller.fetchMedicalData());
              Get.back();
            },
            child: Text("Add"))
      ],
    ),
  );
}
