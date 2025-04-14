import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_clinic_app/domain/entities/clinic_entity.dart';
import 'package:smart_clinic_app/domain/repositories/clinic_repository.dart';

class ClinicRepositoryImpl implements ClinicRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ClinicEntity>> getClinicsForUser(String userId) {
    return _firestore
        .collection('clinics')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ClinicEntity.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<ClinicEntity> getClinic(String clinicId) async {
    final doc = await _firestore.collection('clinics').doc(clinicId).get();
    if (!doc.exists) {
      throw Exception('Clinic not found');
    }
    return ClinicEntity.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<String> createClinic(ClinicEntity clinic) async {
    final docRef = await _firestore.collection('clinics').add({
      'name': clinic.name,
      'address': clinic.address.toMap(),
      'contactInfo': clinic.contactInfo.toMap(),
      'ownerId': clinic.ownerId,
      'logo': clinic.logo,
      'businessHours': clinic.businessHours.map((key, value) => MapEntry(key, value.toMap())),
      'appointmentSettings': clinic.appointmentSettings.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isActive': true,
      'timezone': clinic.timezone,
      'currency': clinic.currency,
      'branding': clinic.branding?.toMap(),
    });
    
    // Add clinic access to owner's user document
    await _firestore.collection('users').doc(clinic.ownerId).update({
      'clinicAccess': FieldValue.arrayUnion([docRef.id]),
    });
    
    return docRef.id;
  }

  @override
  Future<void> updateClinic(ClinicEntity clinic) async {
    await _firestore.collection('clinics').doc(clinic.id).update({
      'name': clinic.name,
      'address': clinic.address.toMap(),
      'contactInfo': clinic.contactInfo.toMap(),
      'logo': clinic.logo,
      'businessHours': clinic.businessHours.map((key, value) => MapEntry(key, value.toMap())),
      'appointmentSettings': clinic.appointmentSettings.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isActive': clinic.isActive,
      'timezone': clinic.timezone,
      'currency': clinic.currency,
      'branding': clinic.branding?.toMap(),
    });
  }

  @override
  Future<void> deleteClinic(String clinicId) async {
    // Get clinic to find owner
    final clinic = await getClinic(clinicId);
    
    // Remove clinic access from owner's user document
    await _firestore.collection('users').doc(clinic.ownerId).update({
      'clinicAccess': FieldValue.arrayRemove([clinicId]),
    });
    
    // Delete clinic document
    await _firestore.collection('clinics').doc(clinicId).delete();
  }

  @override
  Future<List<Map<String, dynamic>>> getClinicStaff(String clinicId) async {
    final staffSnapshot = await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('staff')
        .get();
        
    return staffSnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> addStaffToClinic(String clinicId, String userId, String role) async {
    // Add staff to clinic's staff subcollection
    await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('staff')
        .doc(userId)
        .set({
      'userId': userId,
      'role': role,
      'addedAt': FieldValue.serverTimestamp(),
      'isActive': true,
    });
    
    // Add clinic access to user's document
    await _firestore.collection('users').doc(userId).update({
      'clinicAccess': FieldValue.arrayUnion([clinicId]),
    });
  }

  @override
  Future<void> removeStaffFromClinic(String clinicId, String userId) async {
    // Remove staff from clinic's staff subcollection
    await _firestore
        .collection('clinics')
        .doc(clinicId)
        .collection('staff')
        .doc(userId)
        .delete();
    
    // Remove clinic access from user's document
    await _firestore.collection('users').doc(userId).update({
      'clinicAccess': FieldValue.arrayRemove([clinicId]),
    });
  }
}
