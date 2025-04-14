import 'package:isar/isar.dart';

part 'sync_queue_model.g.dart';

@collection
class SyncQueueModel {
  Id id = Isar.autoIncrement;
  
  late String collectionName; // The collection this sync item belongs to (users, clinics, patients, etc.)
  late String documentId; // Local ID of the document to sync
  late String? firebaseId; // Firebase ID if available (for updates)
  late String operation; // "create", "update", "delete"
  late DateTime createdAt = DateTime.now(); // Initialize with default value
  late int retryCount;
  late bool synced;
  late String? errorMessage;
  late DateTime? lastSyncAttempt;

  // Constructor without createdAt parameter to avoid type mismatch
  SyncQueueModel({
    required this.collectionName,
    required this.documentId,
    this.firebaseId,
    required this.operation,
    this.retryCount = 0,
    this.synced = false,
    this.errorMessage,
    this.lastSyncAttempt,
  });

  // Factory method for creating a sync item
  factory SyncQueueModel.create({
    required String collectionName,
    required String documentId,
    String? firebaseId,
    required String operation,
  }) {
    return SyncQueueModel(
      collectionName: collectionName,
      documentId: documentId,
      firebaseId: firebaseId,
      operation: operation,
    );
  }

  // Mark as synced
  void markAsSynced() {
    synced = true;
    lastSyncAttempt = DateTime.now();
  }

  // Mark as failed
  void markAsFailed(String error) {
    synced = false;
    retryCount++;
    errorMessage = error;
    lastSyncAttempt = DateTime.now();
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'collectionName': collectionName,
      'documentId': documentId,
      'firebaseId': firebaseId,
      'operation': operation,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'synced': synced,
      'errorMessage': errorMessage,
      'lastSyncAttempt': lastSyncAttempt?.toIso8601String(),
    };
  }
}
