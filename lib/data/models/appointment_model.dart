import 'package:isar/isar.dart';
import 'package:smart_clinic_app/domain/entities/appointment_entity.dart';

part 'appointment_model.g.dart';

@collection
class AppointmentModel {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String? firebaseId;
  
  @Index()
  late String patientId;
  
  @Index()
  late String doctorId;
  
  @Index()
  late String clinicId;
  
  @Index()
  late DateTime startTime;
  
  late DateTime endTime;
  late String status; // "scheduled", "confirmed", "completed", "cancelled", "no-show"
  late String type; // "regular", "follow-up", "emergency", "consultation"
  late String? reason;
  late String? notes;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late String? createdBy;
  late String? updatedBy;
  late bool reminderSent;
  late bool isRecurring;
  late RecurringPatternModel? recurringPattern;
  late String? googleCalendarEventId;
  late String? color;
  late DateTime? lastSynced;
  late bool needsSync;

  // Constructor
  AppointmentModel({
    this.firebaseId,
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
    this.lastSynced,
    this.needsSync = false,
  });

  // Convert from Entity to Model
  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      firebaseId: entity.id,
      patientId: entity.patientId,
      doctorId: entity.doctorId,
      clinicId: entity.clinicId,
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      type: entity.type,
      reason: entity.reason,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      reminderSent: entity.reminderSent,
      isRecurring: entity.isRecurring,
      recurringPattern: entity.recurringPattern != null 
          ? RecurringPatternModel.fromEntity(entity.recurringPattern!) 
          : null,
      googleCalendarEventId: entity.googleCalendarEventId,
      color: entity.color,
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  // Convert to Entity
  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: firebaseId,
      patientId: patientId,
      doctorId: doctorId,
      clinicId: clinicId,
      startTime: startTime,
      endTime: endTime,
      status: status,
      type: type,
      reason: reason,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
      reminderSent: reminderSent,
      isRecurring: isRecurring,
      recurringPattern: recurringPattern?.toEntity(),
      googleCalendarEventId: googleCalendarEventId,
      color: color,
    );
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'clinicId': clinicId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'type': type,
      'reason': reason,
      'notes': notes,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
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

@embedded
class RecurringPatternModel {
  late String frequency; // "daily", "weekly", "monthly"
  late int interval;
  late DateTime? endDate;

  // Default constructor with no required parameters for Isar
  RecurringPatternModel({
    this.frequency = 'weekly',
    this.interval = 1,
    this.endDate,
  });

  factory RecurringPatternModel.fromEntity(dynamic entity) {
    return RecurringPatternModel(
      frequency: entity.frequency,
      interval: entity.interval,
      endDate: entity.endDate,
    );
  }

  dynamic toEntity() {
    return {
      'frequency': frequency,
      'interval': interval,
      'endDate': endDate,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'frequency': frequency,
      'interval': interval,
      'endDate': endDate?.toIso8601String(),
    };
  }
}
