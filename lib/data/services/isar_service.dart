import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_clinic_app/data/models/user_model.dart';
import 'package:smart_clinic_app/data/models/clinic_model.dart';
import 'package:smart_clinic_app/data/models/patient_model.dart';
import 'package:smart_clinic_app/data/models/appointment_model.dart';
import 'package:smart_clinic_app/data/models/prescription_model.dart';
import 'package:smart_clinic_app/data/models/sync_queue_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [
          UserModelSchema,
          ClinicModelSchema,
          PatientModelSchema,
          AppointmentModelSchema,
          PrescriptionModelSchema,
          SyncQueueModelSchema,
        ],
        directory: dir.path,
        inspector: true, // Enable inspector in debug mode
      );
    }

    return Future.value(Isar.getInstance());
  }

  // User operations
  Future<void> saveUser(UserModel user) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.userModels.put(user);
    });
  }

  Future<UserModel?> getUser(String uid) async {
    final isar = await db;
    return await isar.userModels.filter().uidEqualTo(uid).findFirst();
  }

  Future<List<UserModel>> getAllUsers() async {
    final isar = await db;
    return await isar.userModels.where().findAll();
  }

  // Clinic operations
  Future<void> saveClinic(ClinicModel clinic) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.clinicModels.put(clinic);
    });
  }

  Future<List<ClinicModel>> getClinicsForUser(String userId) async {
    final isar = await db;
    return await isar.clinicModels.filter().ownerIdEqualTo(userId).findAll();
  }

  Future<ClinicModel?> getClinic(String clinicId) async {
    final isar = await db;
    return await isar.clinicModels.filter().firebaseIdEqualTo(clinicId).findFirst();
  }

  // Patient operations
  Future<void> savePatient(PatientModel patient) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.patientModels.put(patient);
    });
  }

  Future<List<PatientModel>> getPatientsForClinic(String clinicId) async {
    final isar = await db;
    return await isar.patientModels.filter().primaryClinicIdEqualTo(clinicId).findAll();
  }

  Future<PatientModel?> getPatient(String patientId) async {
    final isar = await db;
    return await isar.patientModels.filter().firebaseIdEqualTo(patientId).findFirst();
  }

  // Appointment operations
  Future<void> saveAppointment(AppointmentModel appointment) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.appointmentModels.put(appointment);
    });
  }

  Future<List<AppointmentModel>> getAppointmentsForClinic(String clinicId) async {
    final isar = await db;
    return await isar.appointmentModels.filter().clinicIdEqualTo(clinicId).findAll();
  }

  Future<List<AppointmentModel>> getAppointmentsForDoctor(String doctorId) async {
    final isar = await db;
    return await isar.appointmentModels.filter().doctorIdEqualTo(doctorId).findAll();
  }

  Future<List<AppointmentModel>> getAppointmentsForPatient(String patientId) async {
    final isar = await db;
    return await isar.appointmentModels.filter().patientIdEqualTo(patientId).findAll();
  }

  // Prescription operations
  Future<void> savePrescription(PrescriptionModel prescription) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.prescriptionModels.put(prescription);
    });
  }

  Future<List<PrescriptionModel>> getPrescriptionsForClinic(String clinicId) async {
    final isar = await db;
    return await isar.prescriptionModels.filter().clinicIdEqualTo(clinicId).findAll();
  }

  Future<List<PrescriptionModel>> getPrescriptionsForDoctor(String doctorId) async {
    final isar = await db;
    return await isar.prescriptionModels.filter().doctorIdEqualTo(doctorId).findAll();
  }

  Future<List<PrescriptionModel>> getPrescriptionsForPatient(String patientId) async {
    final isar = await db;
    return await isar.prescriptionModels.filter().patientIdEqualTo(patientId).findAll();
  }

  // Sync queue operations
  Future<void> addToSyncQueue(SyncQueueModel syncItem) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.syncQueueModels.put(syncItem);
    });
  }

  Future<List<SyncQueueModel>> getPendingSyncItems() async {
    final isar = await db;
    return await isar.syncQueueModels.filter().syncedEqualTo(false).findAll();
  }

  Future<void> markSyncItemAsCompleted(int id) async {
    final isar = await db;
    isar.writeTxn(() async {
      final item = await isar.syncQueueModels.get(id);
      if (item != null) {
        item.synced = true;
        await isar.syncQueueModels.put(item);
      }
    });
  }

  // Batch operations for initial sync
  Future<void> saveUsersInBatch(List<UserModel> users) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.userModels.putAll(users);
    });
  }

  Future<void> saveClinicsInBatch(List<ClinicModel> clinics) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.clinicModels.putAll(clinics);
    });
  }

  Future<void> savePatientsInBatch(List<PatientModel> patients) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.patientModels.putAll(patients);
    });
  }

  Future<void> saveAppointmentsInBatch(List<AppointmentModel> appointments) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.appointmentModels.putAll(appointments);
    });
  }

  Future<void> savePrescriptionsInBatch(List<PrescriptionModel> prescriptions) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.prescriptionModels.putAll(prescriptions);
    });
  }

  // Clear database (for logout or reset)
  Future<void> clearAllData() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
