import 'package:flutter/material.dart';
class Task {
  late  String id;
  final String title;
  final String description;
  final String schedule;
  late bool missed;
  late bool completed;
  final DateTime createdAt;

  // Optional fields
  final DateTime? dueDate;
  final String? priority;

  Task({
    this.id='',
    required this.title,
    this.description = '',
    this.completed = false,
    this.missed = false,
    required this.createdAt,
    this.dueDate,
    this.priority,
    required this.schedule,
  });


  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    bool? missed,
    DateTime? createdAt,
    DateTime? dueDate,
    String? priority,
    String? schedule
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      missed: missed??this.missed,
      schedule: schedule??this.schedule,
    );
  }

  // Replace with a custom implementation if needed
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Task &&
              id == other.id &&
              title == other.title &&
              description == other.description &&
              completed == other.completed &&
              missed == other.missed &&
              createdAt == other.createdAt &&
              dueDate == other.dueDate &&
              priority == other.priority;


  @override
  int get hashCode =>
      hashValues([
        id,
        title,
        description,
        completed,
        createdAt,
        dueDate,
        priority,
        missed,
      ],hashCode);

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, completed: $completed, createdAt: $createdAt, dueDate: $dueDate, priority: $priority ,missed:$missed}';
  }

  Map<String, dynamic> toMap() {
    return {
      'schedule': schedule,
      'id': id,
      'title': title,
      'description': description ?? '',
      'completed': completed,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'priority': priority,
      'missed':missed,
    };
  }
  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        title = map['title'] as String,
        description = map['description'] as String? ?? '',
        completed = map['completed'] as bool,
        createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        dueDate = map['dueDate']?.toInt() != null
            ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
            : null,
        missed=map['missed']as bool,
        schedule=map['schedule'] as String,
        priority = map['priority'] as String?;

}
