import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_clinic_app/domain/entities/patient_entity.dart';
import 'package:smart_clinic_app/domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Stream<List<PatientEntity>> getPatientsForClinic(String clinicId) {
    return _firestore
        .collection('patients')
        .where('primaryClinicId', isEqualTo: clinicId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PatientEntity.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<PatientEntity> getPatient(String patientId) async {
    final doc = await _firestore.collection('patients').doc(patientId).get();
    if (!doc.exists) {
      throw Exception('Patient not found');
    }
    return PatientEntity.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<String> createPatient(PatientEntity patient) async {
    final docRef = await _firestore.collection('patients').add({
      'firstName': patient.firstName,
      'lastName': patient.lastName,
      'dateOfBirth': patient.dateOfBirth,
      'gender': patient.gender,
      'contactInfo': patient.contactInfo.toMap(),
      'address': patient.address.toMap(),
      'emergencyContact': patient.emergencyContact.toMap(),
      'insuranceInfo': patient.insuranceInfo?.toMap(),
      'allergies': patient.allergies,
      'bloodType': patient.bloodType,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'primaryDoctorId': patient.primaryDoctorId,
      'primaryClinicId': patient.primaryClinicId,
      'profilePhoto': patient.profilePhoto,
      'notes': patient.notes,
      'isActive': true,
    });
    
    return docRef.id;
  }

  @override
  Future<void> updatePatient(PatientEntity patient) async {
    if (patient.id == null) {
      throw Exception('Cannot update patient without ID');
    }
    
    await _firestore.collection('patients').doc(patient.id).update({
      'firstName': patient.firstName,
      'lastName': patient.lastName,
      'dateOfBirth': patient.dateOfBirth,
      'gender': patient.gender,
      'contactInfo': patient.contactInfo.toMap(),
      'address': patient.address.toMap(),
      'emergencyContact': patient.emergencyContact.toMap(),
      'insuranceInfo': patient.insuranceInfo?.toMap(),
      'allergies': patient.allergies,
      'bloodType': patient.bloodType,
      'updatedAt': FieldValue.serverTimestamp(),
      'primaryDoctorId': patient.primaryDoctorId,
      'primaryClinicId': patient.primaryClinicId,
      'profilePhoto': patient.profilePhoto,
      'notes': patient.notes,
      'isActive': patient.isActive,
    });
  }

  @override
  Future<void> deletePatient(String patientId) async {
    // Soft delete - just mark as inactive
    await _firestore.collection('patients').doc(patientId).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<PatientEntity>> searchPatients(String clinicId, String query) async {
    // Search by name (first or last)
    final queryLower = query.toLowerCase();
    
    final snapshot = await _firestore
        .collection('patients')
        .where('primaryClinicId', isEqualTo: clinicId)
        .where('isActive', isEqualTo: true)
        .get();
    
    // Filter in memory since Firestore doesn't support complex text search
    return snapshot.docs
        .map((doc) => PatientEntity.fromMap(doc.data(), doc.id))
        .where((patient) => 
            patient.firstName.toLowerCase().contains(queryLower) ||
            patient.lastName.toLowerCase().contains(queryLower))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getPatientAttachments(String patientId) async {
    final snapshot = await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('attachments')
        .get();
    
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  @override
  Future<String> addPatientAttachment(
    String patientId, 
    String fileUrl, 
    String fileName, 
    String fileType
  ) async {
    final docRef = await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('attachments')
        .add({
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileType': fileType,
      'uploadedAt': FieldValue.serverTimestamp(),
    });
    
    return docRef.id;
  }

  @override
  Future<void> removePatientAttachment(String patientId, String attachmentId) async {
    // Get the attachment to find the file URL
    final attachmentDoc = await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('attachments')
        .doc(attachmentId)
        .get();
    
    if (attachmentDoc.exists) {
      final fileUrl = attachmentDoc.data()?['fileUrl'] as String?;
      
      // Delete from Firestore
      await _firestore
          .collection('patients')
          .doc(patientId)
          .collection('attachments')
          .doc(attachmentId)
          .delete();
      
      // Delete from Storage if URL exists and is a Firebase Storage URL
      if (fileUrl != null && fileUrl.startsWith('gs://')) {
        try {
          await _storage.refFromURL(fileUrl).delete();
        } catch (e) {
          // Log error but don't fail the operation if storage deletion fails
          print('Error deleting file from storage: $e');
        }
      }
    }
  }
}
