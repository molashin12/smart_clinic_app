import 'package:smart_clinic_app/domain/entities/prescription_entity.dart';

abstract class PrescriptionRepository {
  Stream<List<PrescriptionEntity>> getPrescriptionsForClinic(String clinicId);
  
  Stream<List<PrescriptionEntity>> getPrescriptionsForDoctor(String doctorId);
  
  Stream<List<PrescriptionEntity>> getPrescriptionsForPatient(String patientId);
  
  Future<PrescriptionEntity> getPrescription(String prescriptionId);
  
  Future<String> createPrescription(PrescriptionEntity prescription);
  
  Future<void> updatePrescription(PrescriptionEntity prescription);
  
  Future<void> deletePrescription(String prescriptionId);
  
  Future<void> updatePrescriptionStatus(String prescriptionId, String status);
  
  Future<List<PrescriptionEntity>> getActivePrescriptions(String patientId);
  
  Future<void> markAsFulfilled(String prescriptionId, String pharmacistId);
  
  Future<String> generatePrescriptionPdf(String prescriptionId);
}
