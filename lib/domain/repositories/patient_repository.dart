import 'package:smart_clinic_app/domain/entities/patient_entity.dart';

abstract class PatientRepository {
  Stream<List<PatientEntity>> getPatientsForClinic(String clinicId);
  
  Future<PatientEntity> getPatient(String patientId);
  
  Future<String> createPatient(PatientEntity patient);
  
  Future<void> updatePatient(PatientEntity patient);
  
  Future<void> deletePatient(String patientId);
  
  Future<List<PatientEntity>> searchPatients(String clinicId, String query);
  
  Future<List<Map<String, dynamic>>> getPatientAttachments(String patientId);
  
  Future<String> addPatientAttachment(String patientId, String fileUrl, String fileName, String fileType);
  
  Future<void> removePatientAttachment(String patientId, String attachmentId);
}
