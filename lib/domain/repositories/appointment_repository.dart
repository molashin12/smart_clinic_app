import 'package:smart_clinic_app/domain/entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Stream<List<AppointmentEntity>> getAppointmentsForClinic(String clinicId, {DateTime? startDate, DateTime? endDate});
  
  Stream<List<AppointmentEntity>> getAppointmentsForDoctor(String doctorId, {DateTime? startDate, DateTime? endDate});
  
  Stream<List<AppointmentEntity>> getAppointmentsForPatient(String patientId);
  
  Future<AppointmentEntity> getAppointment(String appointmentId);
  
  Future<String> createAppointment(AppointmentEntity appointment);
  
  Future<void> updateAppointment(AppointmentEntity appointment);
  
  Future<void> deleteAppointment(String appointmentId);
  
  Future<void> updateAppointmentStatus(String appointmentId, String status);
  
  Future<List<AppointmentEntity>> getAppointmentsByDate(String clinicId, DateTime date);
  
  Future<bool> isTimeSlotAvailable(String doctorId, DateTime startTime, DateTime endTime);
  
  Future<void> syncWithGoogleCalendar(String appointmentId);
}
