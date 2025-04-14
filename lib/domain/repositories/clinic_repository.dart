import 'package:smart_clinic_app/domain/entities/clinic_entity.dart';

abstract class ClinicRepository {
  Stream<List<ClinicEntity>> getClinicsForUser(String userId);
  
  Future<ClinicEntity> getClinic(String clinicId);
  
  Future<String> createClinic(ClinicEntity clinic);
  
  Future<void> updateClinic(ClinicEntity clinic);
  
  Future<void> deleteClinic(String clinicId);
  
  Future<List<Map<String, dynamic>>> getClinicStaff(String clinicId);
  
  Future<void> addStaffToClinic(String clinicId, String userId, String role);
  
  Future<void> removeStaffFromClinic(String clinicId, String userId);
}
