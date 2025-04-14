import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_clinic_app/domain/entities/appointment_entity.dart';
import 'package:smart_clinic_app/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<AppointmentEntity>> getAppointmentsForClinic(
    String clinicId, 
    {DateTime? startDate, DateTime? endDate}
  ) {
    Query query = _firestore
        .collection('appointments')
        .where('clinicId', isEqualTo: clinicId);
    
    if (startDate != null) {
      query = query.where('startTime', isGreaterThanOrEqualTo: startDate);
    }
    
    if (endDate != null) {
      query = query.where('startTime', isLessThanOrEqualTo: endDate);
    }
    
    return query
        .orderBy('startTime')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AppointmentEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  @override
  Stream<List<AppointmentEntity>> getAppointmentsForDoctor(
    String doctorId, 
    {DateTime? startDate, DateTime? endDate}
  ) {
    Query query = _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId);
    
    if (startDate != null) {
      query = query.where('startTime', isGreaterThanOrEqualTo: startDate);
    }
    
    if (endDate != null) {
      query = query.where('startTime', isLessThanOrEqualTo: endDate);
    }
    
    return query
        .orderBy('startTime')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AppointmentEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  @override
  Stream<List<AppointmentEntity>> getAppointmentsForPatient(String patientId) {
    return _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AppointmentEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  @override
  Future<AppointmentEntity> getAppointment(String appointmentId) async {
    final doc = await _firestore.collection('appointments').doc(appointmentId).get();
    if (!doc.exists) {
      throw Exception('Appointment not found');
    }
    return AppointmentEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  @override
  Future<String> createAppointment(AppointmentEntity appointment) async {
    // Check if time slot is available
    final isAvailable = await isTimeSlotAvailable(
      appointment.doctorId, 
      appointment.startTime, 
      appointment.endTime
    );
    
    if (!isAvailable) {
      throw Exception('Time slot is not available');
    }
    
    final docRef = await _firestore.collection('appointments').add({
      'patientId': appointment.patientId,
      'doctorId': appointment.doctorId,
      'clinicId': appointment.clinicId,
      'startTime': appointment.startTime,
      'endTime': appointment.endTime,
      'status': appointment.status,
      'type': appointment.type,
      'reason': appointment.reason,
      'notes': appointment.notes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': appointment.createdBy,
      'updatedBy': appointment.updatedBy,
      'reminderSent': appointment.reminderSent,
      'isRecurring': appointment.isRecurring,
      'recurringPattern': appointment.recurringPattern?.toMap(),
      'googleCalendarEventId': appointment.googleCalendarEventId,
      'color': appointment.color,
    });
    
    return docRef.id;
  }

  @override
  Future<void> updateAppointment(AppointmentEntity appointment) async {
    if (appointment.id == null) {
      throw Exception('Cannot update appointment without ID');
    }
    
    await _firestore.collection('appointments').doc(appointment.id).update({
      'patientId': appointment.patientId,
      'doctorId': appointment.doctorId,
      'clinicId': appointment.clinicId,
      'startTime': appointment.startTime,
      'endTime': appointment.endTime,
      'status': appointment.status,
      'type': appointment.type,
      'reason': appointment.reason,
      'notes': appointment.notes,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': appointment.updatedBy,
      'reminderSent': appointment.reminderSent,
      'isRecurring': appointment.isRecurring,
      'recurringPattern': appointment.recurringPattern?.toMap(),
      'googleCalendarEventId': appointment.googleCalendarEventId,
      'color': appointment.color,
    });
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).delete();
  }

  @override
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByDate(String clinicId, DateTime date) async {
    // Create start and end of the day
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final snapshot = await _firestore
        .collection('appointments')
        .where('clinicId', isEqualTo: clinicId)
        .where('startTime', isGreaterThanOrEqualTo: startOfDay)
        .where('startTime', isLessThanOrEqualTo: endOfDay)
        .orderBy('startTime')
        .get();
    
    return snapshot.docs
        .map((doc) => AppointmentEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  @override
  Future<bool> isTimeSlotAvailable(String doctorId, DateTime startTime, DateTime endTime) async {
    // Check if there are any overlapping appointments
    final snapshot = await _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('status', whereIn: ['scheduled', 'confirmed'])
        .get();
    
    // Check for overlaps
    for (final doc in snapshot.docs) {
      final appointment = AppointmentEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      
      // Skip if it's the same appointment (for updates)
      if (appointment.id == doctorId) continue;
      
      // Check for overlap
      if (startTime.isBefore(appointment.endTime) && 
          endTime.isAfter(appointment.startTime)) {
        return false; // Overlap found
      }
    }
    
    return true; // No overlaps
  }

  @override
  Future<void> syncWithGoogleCalendar(String appointmentId) async {
    // This would integrate with Google Calendar API
    // For now, just mark as synced
    await _firestore.collection('appointments').doc(appointmentId).update({
      'googleCalendarSynced': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
