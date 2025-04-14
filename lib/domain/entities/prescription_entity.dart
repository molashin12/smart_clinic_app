import 'package:cloud_firestore/cloud_firestore.dart';

class PrescriptionEntity {
  final String? id;
  final String patientId;
  final String doctorId;
  final String clinicId;
  final String? recordId;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String status; // "active", "completed", "cancelled"
  final List<Medication> medications;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? pharmacistId;
  final DateTime? fulfilledDate;

  PrescriptionEntity({
    this.id,
    required this.patientId,
    required this.doctorId,
    required this.clinicId,
    this.recordId,
    required this.issueDate,
    this.expiryDate,
    required this.status,
    required this.medications,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.pharmacistId,
    this.fulfilledDate,
  });

  PrescriptionEntity copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? clinicId,
    String? recordId,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? status,
    List<Medication>? medications,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? pharmacistId,
    DateTime? fulfilledDate,
  }) {
    return PrescriptionEntity(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      clinicId: clinicId ?? this.clinicId,
      recordId: recordId ?? this.recordId,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      pharmacistId: pharmacistId ?? this.pharmacistId,
      fulfilledDate: fulfilledDate ?? this.fulfilledDate,
    );
  }

  factory PrescriptionEntity.fromMap(Map<String, dynamic> map, String docId) {
    return PrescriptionEntity(
      id: docId,
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      clinicId: map['clinicId'] ?? '',
      recordId: map['recordId'],
      issueDate: map['issueDate'] != null 
          ? (map['issueDate'] as Timestamp).toDate() 
          : DateTime.now(),
      expiryDate: map['expiryDate'] != null 
          ? (map['expiryDate'] as Timestamp).toDate() 
          : null,
      status: map['status'] ?? 'active',
      medications: map['medications'] != null 
          ? List<Medication>.from(
              (map['medications'] as List).map(
                (x) => Medication.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      notes: map['notes'],
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      pharmacistId: map['pharmacistId'],
      fulfilledDate: map['fulfilledDate'] != null 
          ? (map['fulfilledDate'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'clinicId': clinicId,
      'recordId': recordId,
      'issueDate': issueDate,
      'expiryDate': expiryDate,
      'status': status,
      'medications': medications.map((x) => x.toMap()).toList(),
      'notes': notes,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'pharmacistId': pharmacistId,
      'fulfilledDate': fulfilledDate,
    };
  }
}

class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String? instructions;
  final int quantity;
  final int? refills;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
    required this.quantity,
    this.refills,
  });

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      duration: map['duration'] ?? '',
      instructions: map['instructions'],
      quantity: map['quantity'] ?? 0,
      refills: map['refills'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
      'quantity': quantity,
      'refills': refills,
    };
  }

  Medication copyWith({
    String? name,
    String? dosage,
    String? frequency,
    String? duration,
    String? instructions,
    int? quantity,
    int? refills,
  }) {
    return Medication(
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
      quantity: quantity ?? this.quantity,
      refills: refills ?? this.refills,
    );
  }
}
