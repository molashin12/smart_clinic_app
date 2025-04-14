import 'package:isar/isar.dart';
import 'package:smart_clinic_app/domain/entities/prescription_entity.dart';

part 'prescription_model.g.dart';

@collection
class PrescriptionModel {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String? firebaseId;
  
  @Index()
  late String patientId;
  
  @Index()
  late String doctorId;
  
  @Index()
  late String clinicId;
  
  late String? recordId;
  
  @Index()
  late DateTime issueDate;
  
  late DateTime? expiryDate;
  late String status; // "active", "completed", "cancelled"
  late List<MedicationModel> medications;
  late String? notes;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late String? createdBy;
  late String? updatedBy;
  late String? pharmacistId;
  late DateTime? fulfilledDate;
  late DateTime? lastSynced;
  late bool needsSync;

  // Constructor
  PrescriptionModel({
    this.firebaseId,
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
    this.lastSynced,
    this.needsSync = false,
  });

  // Convert from Entity to Model
  factory PrescriptionModel.fromEntity(PrescriptionEntity entity) {
    List<MedicationModel> medicationModels = [];
    
    if (entity.medications is List) {
      for (var med in entity.medications) {
        medicationModels.add(MedicationModel.fromEntity(med));
      }
    }

    return PrescriptionModel(
      firebaseId: entity.id,
      patientId: entity.patientId,
      doctorId: entity.doctorId,
      clinicId: entity.clinicId,
      recordId: entity.recordId,
      issueDate: entity.issueDate,
      expiryDate: entity.expiryDate,
      status: entity.status,
      medications: medicationModels,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      pharmacistId: entity.pharmacistId,
      fulfilledDate: entity.fulfilledDate,
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  // Convert to Entity
  PrescriptionEntity toEntity() {
    return PrescriptionEntity(
      id: firebaseId,
      patientId: patientId,
      doctorId: doctorId,
      clinicId: clinicId,
      recordId: recordId,
      issueDate: issueDate,
      expiryDate: expiryDate,
      status: status,
      medications: medications.map((med) => med.toEntity()).toList(),
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
      pharmacistId: pharmacistId,
      fulfilledDate: fulfilledDate,
    );
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'clinicId': clinicId,
      'recordId': recordId,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'status': status,
      'medications': medications.map((med) => med.toMap()).toList(),
      'notes': notes,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'pharmacistId': pharmacistId,
      'fulfilledDate': fulfilledDate?.toIso8601String(),
    };
  }
}

@embedded
class MedicationModel {
  late String name;
  late String dosage;
  late String frequency;
  late String duration;
  late String? instructions;
  late int quantity;
  late int? refills;

  // Default constructor with no required parameters for Isar
  MedicationModel({
    this.name = '',
    this.dosage = '',
    this.frequency = '',
    this.duration = '',
    this.instructions,
    this.quantity = 0,
    this.refills,
  });

  factory MedicationModel.fromEntity(dynamic entity) {
    return MedicationModel(
      name: entity['name'] ?? entity.name ?? '',
      dosage: entity['dosage'] ?? entity.dosage ?? '',
      frequency: entity['frequency'] ?? entity.frequency ?? '',
      duration: entity['duration'] ?? entity.duration ?? '',
      instructions: entity['instructions'] ?? entity.instructions,
      quantity: entity['quantity'] ?? entity.quantity ?? 0,
      refills: entity['refills'] ?? entity.refills,
    );
  }

  dynamic toEntity() {
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
}
