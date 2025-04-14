import 'package:isar/isar.dart';
import 'package:smart_clinic_app/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@collection
class UserModel {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String uid;
  
  late String? email;
  late String? displayName;
  late String? phoneNumber;
  late String? photoURL;
  late String? role;
  late List<String>? clinicAccess;
  late String? subscriptionTier;
  late String? preferredLanguage;
  late DateTime? lastSynced;
  late bool needsSync;

  // Constructor
  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    this.role,
    this.clinicAccess,
    this.subscriptionTier,
    this.preferredLanguage,
    this.lastSynced,
    this.needsSync = false,
  });

  // Convert from Entity to Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid ?? '',  // Ensure uid is never null
      email: entity.email,
      displayName: entity.displayName,
      phoneNumber: entity.phoneNumber,
      photoURL: entity.photoURL,
      role: entity.role,
      clinicAccess: entity.clinicAccess != null 
          ? List<String>.from(entity.clinicAccess!)
          : null,
      subscriptionTier: entity.subscriptionTier,
      preferredLanguage: entity.preferredLanguage,
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  // Convert to Entity
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      phoneNumber: phoneNumber,
      photoURL: photoURL,
      role: role,
      clinicAccess: clinicAccess,
      subscriptionTier: subscriptionTier,
      preferredLanguage: preferredLanguage,
    );
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'role': role,
      'clinicAccess': clinicAccess,
      'subscriptionTier': subscriptionTier,
      'preferredLanguage': preferredLanguage,
    };
  }
}
