import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_clinic_app/domain/entities/prescription_entity.dart';
import 'package:smart_clinic_app/domain/repositories/prescription_repository.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Stream<List<PrescriptionEntity>> getPrescriptionsForClinic(String clinicId) {
    return _firestore
        .collection('prescriptions')
        .where('clinicId', isEqualTo: clinicId)
        .orderBy('issueDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PrescriptionEntity.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Stream<List<PrescriptionEntity>> getPrescriptionsForDoctor(String doctorId) {
    return _firestore
        .collection('prescriptions')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('issueDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PrescriptionEntity.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Stream<List<PrescriptionEntity>> getPrescriptionsForPatient(String patientId) {
    return _firestore
        .collection('prescriptions')
        .where('patientId', isEqualTo: patientId)
        .orderBy('issueDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PrescriptionEntity.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<PrescriptionEntity> getPrescription(String prescriptionId) async {
    final doc = await _firestore.collection('prescriptions').doc(prescriptionId).get();
    if (!doc.exists) {
      throw Exception('Prescription not found');
    }
    return PrescriptionEntity.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<String> createPrescription(PrescriptionEntity prescription) async {
    final docRef = await _firestore.collection('prescriptions').add({
      'patientId': prescription.patientId,
      'doctorId': prescription.doctorId,
      'clinicId': prescription.clinicId,
      'recordId': prescription.recordId,
      'issueDate': prescription.issueDate,
      'expiryDate': prescription.expiryDate,
      'status': prescription.status,
      'medications': prescription.medications.map((med) => med.toMap()).toList(),
      'notes': prescription.notes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': prescription.createdBy,
      'updatedBy': prescription.updatedBy,
      'pharmacistId': prescription.pharmacistId,
      'fulfilledDate': prescription.fulfilledDate,
    });
    
    return docRef.id;
  }

  @override
  Future<void> updatePrescription(PrescriptionEntity prescription) async {
    if (prescription.id == null) {
      throw Exception('Cannot update prescription without ID');
    }
    
    await _firestore.collection('prescriptions').doc(prescription.id).update({
      'patientId': prescription.patientId,
      'doctorId': prescription.doctorId,
      'clinicId': prescription.clinicId,
      'recordId': prescription.recordId,
      'issueDate': prescription.issueDate,
      'expiryDate': prescription.expiryDate,
      'status': prescription.status,
      'medications': prescription.medications.map((med) => med.toMap()).toList(),
      'notes': prescription.notes,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': prescription.updatedBy,
      'pharmacistId': prescription.pharmacistId,
      'fulfilledDate': prescription.fulfilledDate,
    });
  }

  @override
  Future<void> deletePrescription(String prescriptionId) async {
    await _firestore.collection('prescriptions').doc(prescriptionId).delete();
  }

  @override
  Future<void> updatePrescriptionStatus(String prescriptionId, String status) async {
    await _firestore.collection('prescriptions').doc(prescriptionId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<PrescriptionEntity>> getActivePrescriptions(String patientId) async {
    final snapshot = await _firestore
        .collection('prescriptions')
        .where('patientId', isEqualTo: patientId)
        .where('status', isEqualTo: 'active')
        .orderBy('issueDate', descending: true)
        .get();
    
    return snapshot.docs
        .map((doc) => PrescriptionEntity.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> markAsFulfilled(String prescriptionId, String pharmacistId) async {
    await _firestore.collection('prescriptions').doc(prescriptionId).update({
      'status': 'completed',
      'pharmacistId': pharmacistId,
      'fulfilledDate': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<String> generatePrescriptionPdf(String prescriptionId) async {
    // In a real implementation, this would generate a PDF and upload it to Firebase Storage
    // For now, we'll just return a placeholder URL
    
    final prescription = await getPrescription(prescriptionId);
    
    // Create a reference to the PDF file in Firebase Storage
    final storageRef = _storage.ref().child('prescriptions/$prescriptionId.pdf');
    
    // In a real implementation, we would generate the PDF here and upload it
    // For now, we'll just return the reference URL
    return await storageRef.getDownloadURL().catchError((error) {
      // If the file doesn't exist yet, return a placeholder
      return 'https://example.com/prescription_$prescriptionId.pdf';
    });
  }
}
