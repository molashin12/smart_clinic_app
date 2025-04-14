import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_clinic_app/data/models/sync_queue_model.dart';
import 'package:smart_clinic_app/data/services/isar_service.dart';
import 'package:smart_clinic_app/domain/repositories/auth_repository.dart';
import 'package:smart_clinic_app/domain/repositories/clinic_repository.dart';
import 'package:smart_clinic_app/domain/repositories/patient_repository.dart';
import 'package:smart_clinic_app/domain/repositories/appointment_repository.dart';
import 'package:smart_clinic_app/domain/repositories/prescription_repository.dart';
import 'package:smart_clinic_app/domain/entities/clinic_entity.dart';
import 'package:smart_clinic_app/domain/entities/patient_entity.dart';
import 'package:smart_clinic_app/domain/entities/appointment_entity.dart';
import 'package:smart_clinic_app/domain/entities/prescription_entity.dart';

class SyncService {
  // Changed from final to late to allow initialization in factory constructor
  late IsarService _isarService;
  late AuthRepository _authRepository;
  late ClinicRepository _clinicRepository;
  late PatientRepository _patientRepository;
  late AppointmentRepository _appointmentRepository;
  late PrescriptionRepository _prescriptionRepository;
  
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
  bool _isSyncing = false;
  Timer? _syncTimer;
  
  // Singleton pattern
  static final SyncService _instance = SyncService._internal();
  
  factory SyncService({
    required IsarService isarService,
    required AuthRepository authRepository,
    required ClinicRepository clinicRepository,
    required PatientRepository patientRepository,
    required AppointmentRepository appointmentRepository,
    required PrescriptionRepository prescriptionRepository,
  }) {
    _instance._isarService = isarService;
    _instance._authRepository = authRepository;
    _instance._clinicRepository = clinicRepository;
    _instance._patientRepository = patientRepository;
    _instance._appointmentRepository = appointmentRepository;
    _instance._prescriptionRepository = prescriptionRepository;
    return _instance;
  }
  
  SyncService._internal();
  
  void initialize() {
    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        // We have connectivity, try to sync
        syncData();
      }
    });
    
    // Set up periodic sync (every 15 minutes)
    _syncTimer = Timer.periodic(const Duration(minutes: 15), (timer) async {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        syncData();
      }
    });
    
    // Initial sync check
    _checkConnectivityAndSync();
  }
  
  Future<void> _checkConnectivityAndSync() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      syncData();
    }
  }
  
  Future<void> syncData() async {
    if (_isSyncing) return; // Prevent multiple syncs at the same time
    
    _isSyncing = true;
    
    try {
      // Check if user is authenticated
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _isSyncing = false;
        return;
      }
      
      // 1. First, process any pending sync queue items (local changes to push to Firebase)
      await _processSyncQueue();
      
      // 2. Then, pull any new data from Firebase to local database
      await _pullDataFromFirebase();
      
    } catch (e) {
      print('Sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }
  
  Future<void> _processSyncQueue() async {
    final pendingSyncItems = await _isarService.getPendingSyncItems();
    
    for (final syncItem in pendingSyncItems) {
      try {
        await _processSyncItem(syncItem);
        await _isarService.markSyncItemAsCompleted(syncItem.id);
      } catch (e) {
        // Mark as failed with error message
        syncItem.markAsFailed(e.toString());
        await _isarService.addToSyncQueue(syncItem);
      }
    }
  }
  
  Future<void> _processSyncItem(SyncQueueModel syncItem) async {
    switch (syncItem.collectionName) {
      case 'clinics':
        await _processClinicSync(syncItem);
        break;
      case 'patients':
        await _processPatientSync(syncItem);
        break;
      case 'appointments':
        await _processAppointmentSync(syncItem);
        break;
      case 'prescriptions':
        await _processPrescriptionSync(syncItem);
        break;
      default:
        throw Exception('Unknown collection: ${syncItem.collectionName}');
    }
  }
  
  Future<void> _processClinicSync(SyncQueueModel syncItem) async {
    final clinic = await _isarService.getClinic(syncItem.documentId);
    if (clinic == null) {
      throw Exception('Clinic not found in local database');
    }
    
    switch (syncItem.operation) {
      case 'create':
        final clinicId = await _clinicRepository.createClinic(clinic.toEntity());
        // Update local clinic with Firebase ID
        clinic.firebaseId = clinicId;
        await _isarService.saveClinic(clinic);
        break;
      case 'update':
        if (clinic.firebaseId == null) {
          throw Exception('Cannot update clinic without Firebase ID');
        }
        await _clinicRepository.updateClinic(clinic.toEntity());
        break;
      case 'delete':
        if (clinic.firebaseId == null) {
          throw Exception('Cannot delete clinic without Firebase ID');
        }
        await _clinicRepository.deleteClinic(clinic.firebaseId!);
        break;
      default:
        throw Exception('Unknown operation: ${syncItem.operation}');
    }
  }
  
  Future<void> _processPatientSync(SyncQueueModel syncItem) async {
    final patient = await _isarService.getPatient(syncItem.documentId);
    if (patient == null) {
      throw Exception('Patient not found in local database');
    }
    
    switch (syncItem.operation) {
      case 'create':
        final patientId = await _patientRepository.createPatient(patient.toEntity());
        // Update local patient with Firebase ID
        patient.firebaseId = patientId;
        await _isarService.savePatient(patient);
        break;
      case 'update':
        if (patient.firebaseId == null) {
          throw Exception('Cannot update patient without Firebase ID');
        }
        await _patientRepository.updatePatient(patient.toEntity());
        break;
      case 'delete':
        if (patient.firebaseId == null) {
          throw Exception('Cannot delete patient without Firebase ID');
        }
        await _patientRepository.deletePatient(patient.firebaseId!);
        break;
      default:
        throw Exception('Unknown operation: ${syncItem.operation}');
    }
  }
  
  Future<void> _processAppointmentSync(SyncQueueModel syncItem) async {
    final appointment = await _isarService.getAppointment(syncItem.documentId);
    if (appointment == null) {
      throw Exception('Appointment not found in local database');
    }
    
    switch (syncItem.operation) {
      case 'create':
        final appointmentId = await _appointmentRepository.createAppointment(appointment.toEntity());
        // Update local appointment with Firebase ID
        appointment.firebaseId = appointmentId;
        await _isarService.saveAppointment(appointment);
        break;
      case 'update':
        if (appointment.firebaseId == null) {
          throw Exception('Cannot update appointment without Firebase ID');
        }
        await _appointmentRepository.updateAppointment(appointment.toEntity());
        break;
      case 'delete':
        if (appointment.firebaseId == null) {
          throw Exception('Cannot delete appointment without Firebase ID');
        }
        await _appointmentRepository.deleteAppointment(appointment.firebaseId!);
        break;
      default:
        throw Exception('Unknown operation: ${syncItem.operation}');
    }
  }
  
  Future<void> _processPrescriptionSync(SyncQueueModel syncItem) async {
    final prescription = await _isarService.getPrescription(syncItem.documentId);
    if (prescription == null) {
      throw Exception('Prescription not found in local database');
    }
    
    switch (syncItem.operation) {
      case 'create':
        final prescriptionId = await _prescriptionRepository.createPrescription(prescription.toEntity());
        // Update local prescription with Firebase ID
        prescription.firebaseId = prescriptionId;
        await _isarService.savePrescription(prescription);
        break;
      case 'update':
        if (prescription.firebaseId == null) {
          throw Exception('Cannot update prescription without Firebase ID');
        }
        await _prescriptionRepository.updatePrescription(prescription.toEntity());
        break;
      case 'delete':
        if (prescription.firebaseId == null) {
          throw Exception('Cannot delete prescription without Firebase ID');
        }
        await _prescriptionRepository.deletePrescription(prescription.firebaseId!);
        break;
      default:
        throw Exception('Unknown operation: ${syncItem.operation}');
    }
  }
  
  Future<void> _pullDataFromFirebase() async {
    final currentUser = await _authRepository.getCurrentUser();
    if (currentUser == null) return;
    
    try {
      // Get user's clinics - Fixed stream handling
      List<ClinicEntity> clinics = [];
      await _clinicRepository.getClinicsForUser(currentUser.uid)
          .first
          .then((clinicList) {
        clinics = clinicList;
      });
      
      for (final clinic in clinics) {
        if (clinic.id == null) continue;
        
        // Save clinic to local database
        await _isarService.saveClinic(clinic.toModel());
        
        // Get patients for this clinic - Fixed stream handling
        List<PatientEntity> patients = [];
        await _patientRepository.getPatientsForClinic(clinic.id!)
            .first
            .then((patientList) {
          patients = patientList;
        });
        
        for (final patient in patients) {
          await _isarService.savePatient(patient.toModel());
        }
        
        // Get appointments for this clinic - Fixed stream handling
        List<AppointmentEntity> appointments = [];
        await _appointmentRepository.getAppointmentsForClinic(clinic.id!)
            .first
            .then((appointmentList) {
          appointments = appointmentList;
        });
        
        for (final appointment in appointments) {
          await _isarService.saveAppointment(appointment.toModel());
        }
        
        // Get prescriptions for this clinic - Fixed stream handling
        List<PrescriptionEntity> prescriptions = [];
        await _prescriptionRepository.getPrescriptionsForClinic(clinic.id!)
            .first
            .then((prescriptionList) {
          prescriptions = prescriptionList;
        });
        
        for (final prescription in prescriptions) {
          await _isarService.savePrescription(prescription.toModel());
        }
      }
    } catch (e) {
      print('Error pulling data from Firebase: $e');
    }
  }
  
  // Add a new item to the sync queue
  Future<void> addToSyncQueue({
    required String collectionName,
    required String documentId,
    String? firebaseId,
    required String operation,
  }) async {
    final syncItem = SyncQueueModel.create(
      collectionName: collectionName,
      documentId: documentId,
      firebaseId: firebaseId,
      operation: operation,
    );
    
    await _isarService.addToSyncQueue(syncItem);
    
    // Try to sync immediately if we have connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none && !_isSyncing) {
      syncData();
    }
  }
  
  // Force a sync
  Future<void> forceSyncData() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      return syncData();
    } else {
      throw Exception('No internet connection available');
    }
  }
  
  // Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
  }
}
