import 'package:flutter/material.dart';

class Medication {
  late String id;
  final String name;
  final String dosage;
  final String water;
  final String unit;
  final String schedule;
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.unit,
    required this.schedule,
    required this.startDate,
    this.endDate,
    this.notes,
    required this.water,
  });
  factory Medication.fromMap(Map<String, dynamic> map) => Medication(
    id: map['id'],
    name: map['name'],
    dosage: map['dosage'],
    unit: map['unit'],
    schedule: map['schedule'],
    startDate: DateTime.parse(map['startDate']), // Parse string back to DateTime
    endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null, // Handle optional endDate
    notes: map['notes'], water: map['water'],
  );


  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'dosage': dosage,
    'unit': unit,
    'schedule': schedule,
    'startDate': startDate.toIso8601String(), // Convert DateTime to string for storage
    'endDate': endDate?.toIso8601String(), // Handle optional endDate
    'notes': notes,
    'water':water
  };

}

class MedicationProvider with ChangeNotifier {
  List<Medication> medications = [];

  void addMedication(Medication medication) {
    medications.add(medication);
    notifyListeners();
  }

// ... similar to PatientController methods ...
}
@immutable
abstract class AdherenceEvent {}

class AddAdherenceEvent extends AdherenceEvent {
  final Medication medication;
  final bool taken;
  final String? note;

  AddAdherenceEvent({required this.medication, required this.taken, this.note});
}