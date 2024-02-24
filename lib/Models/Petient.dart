import 'package:get/get.dart';
class Patient {
  final int id;
  final String name;
  final DateTime? dateOfBirth;
  final String? medicalHistory;

  const Patient({
    required this.id,
    required this.name,
    this.dateOfBirth,
    this.medicalHistory,
  });

  factory Patient.fromMap(Map<String, dynamic> map) => Patient(
    id: map['id'],
    name: map['name'],
    dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth']) : null,
    medicalHistory: map['medicalHistory'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'medicalHistory': medicalHistory,
  };
}

class PatientController extends GetxController {
  RxList<Patient> patients = <Patient>[].obs;

  void addPatient(Patient patient) => patients.add(patient);
  void updatePatient(Patient patient) => patients[patients.indexWhere((p) => p.id == patient.id)] = patient;
  void deletePatient(Patient patient) => patients.removeWhere((p) => p.id == patient.id);
}
