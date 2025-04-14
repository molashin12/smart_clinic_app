import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentEntity {
  final String? id;
  final String patientId;
  final String doctorId;
  final String clinicId;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // "scheduled", "confirmed", "completed", "cancelled", "no-show"
  final String type; // "regular", "follow-up", "emergency", "consultation"
  final String? reason;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final bool reminderSent;
  final bool isRecurring;
  final RecurringPattern? recurringPattern;
  final String? googleCalendarEventId;
  final String? color;

  AppointmentEntity({
    this.id,
    required this.patientId,
    required this.doctorId,
    required this.clinicId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.type,
    this.reason,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.reminderSent = false,
    this.isRecurring = false,
    this.recurringPattern,
    this.googleCalendarEventId,
    this.color,
  });

  AppointmentEntity copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? clinicId,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? type,
    String? reason,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    bool? reminderSent,
    bool? isRecurring,
    RecurringPattern? recurringPattern,
    String? googleCalendarEventId,
    String? color,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      clinicId: clinicId ?? this.clinicId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      type: type ?? this.type,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      reminderSent: reminderSent ?? this.reminderSent,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      googleCalendarEventId: googleCalendarEventId ?? this.googleCalendarEventId,
      color: color ?? this.color,
    );
  }

  factory AppointmentEntity.fromMap(Map<String, dynamic> map, String docId) {
    return AppointmentEntity(
      id: docId,
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      clinicId: map['clinicId'] ?? '',
      startTime: map['startTime'] != null 
          ? (map['startTime'] as Timestamp).toDate() 
          : DateTime.now(),
      endTime: map['endTime'] != null 
          ? (map['endTime'] as Timestamp).toDate() 
          : DateTime.now().add(const Duration(minutes: 30)),
      status: map['status'] ?? 'scheduled',
      type: map['type'] ?? 'regular',
      reason: map['reason'],
      notes: map['notes'],
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      reminderSent: map['reminderSent'] ?? false,
      isRecurring: map['isRecurring'] ?? false,
      recurringPattern: map['recurringPattern'] != null 
          ? RecurringPattern.fromMap(map['recurringPattern'] as Map<String, dynamic>) 
          : null,
      googleCalendarEventId: map['googleCalendarEventId'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'clinicId': clinicId,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'type': type,
      'reason': reason,
      'notes': notes,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'reminderSent': reminderSent,
      'isRecurring': isRecurring,
      'recurringPattern': recurringPattern?.toMap(),
      'googleCalendarEventId': googleCalendarEventId,
      'color': color,
    };
  }
}

class RecurringPattern {
  final String frequency; // "daily", "weekly", "monthly"
  final int interval;
  final DateTime? endDate;

  RecurringPattern({
    required this.frequency,
    required this.interval,
    this.endDate,
  });

  factory RecurringPattern.fromMap(Map<String, dynamic> map) {
    return RecurringPattern(
      frequency: map['frequency'] ?? 'weekly',
      interval: map['interval'] ?? 1,
      endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'frequency': frequency,
      'interval': interval,
      'endDate': endDate,
    };
  }
}
