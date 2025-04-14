import 'package:isar/isar.dart';
import 'package:smart_clinic_app/domain/entities/patient_entity.dart';

part 'patient_model.g.dart';

@collection
class PatientModel {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String? firebaseId;
  
  late String firstName;
  late String lastName;
  late DateTime dateOfBirth;
  late String gender;
  late PatientContactInfoModel contactInfo;
  late AddressModel address;
  late EmergencyContactModel emergencyContact;
  late InsuranceInfoModel? insuranceInfo;
  late List<String> allergies;
  late String? bloodType;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late String primaryDoctorId;
  late String primaryClinicId;
  late String? profilePhoto;
  late String? notes;
  late bool isActive;
  late DateTime? lastSynced;
  late bool needsSync;

  // Constructor
  PatientModel({
    this.firebaseId,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.contactInfo,
    required this.address,
    required this.emergencyContact,
    this.insuranceInfo,
    this.allergies = const [],
    this.bloodType,
    this.createdAt,
    this.updatedAt,
    required this.primaryDoctorId,
    required this.primaryClinicId,
    this.profilePhoto,
    this.notes,
    this.isActive = true,
    this.lastSynced,
    this.needsSync = false,
  });

  // Get full name
  String get fullName => '$firstName $lastName';
  
  // Calculate age
  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month || 
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // Convert from Entity to Model
  factory PatientModel.fromEntity(PatientEntity entity) {
    return PatientModel(
      firebaseId: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      contactInfo: PatientContactInfoModel.fromEntity(entity.contactInfo),
      address: AddressModel.fromEntity(entity.address),
      emergencyContact: EmergencyContactModel.fromEntity(entity.emergencyContact),
      insuranceInfo: entity.insuranceInfo != null 
          ? InsuranceInfoModel.fromEntity(entity.insuranceInfo!) 
          : null,
      allergies: entity.allergies ?? [],
      bloodType: entity.bloodType,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      primaryDoctorId: entity.primaryDoctorId,
      primaryClinicId: entity.primaryClinicId,
      profilePhoto: entity.profilePhoto,
      notes: entity.notes,
      isActive: entity.isActive,
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  // Convert to Entity
  PatientEntity toEntity() {
    return PatientEntity(
      id: firebaseId,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      contactInfo: contactInfo.toEntity(),
      address: address.toEntity(),
      emergencyContact: emergencyContact.toEntity(),
      insuranceInfo: insuranceInfo?.toEntity(),
      allergies: allergies,
      bloodType: bloodType,
      createdAt: createdAt,
      updatedAt: updatedAt,
      primaryDoctorId: primaryDoctorId,
      primaryClinicId: primaryClinicId,
      profilePhoto: profilePhoto,
      notes: notes,
      isActive: isActive,
    );
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'contactInfo': contactInfo.toMap(),
      'address': address.toMap(),
      'emergencyContact': emergencyContact.toMap(),
      'insuranceInfo': insuranceInfo?.toMap(),
      'allergies': allergies,
      'bloodType': bloodType,
      'primaryDoctorId': primaryDoctorId,
      'primaryClinicId': primaryClinicId,
      'profilePhoto': profilePhoto,
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }
}

@embedded
class PatientContactInfoModel {
  late String phone;
  late String? email;
  late String? alternatePhone;

  // Default constructor with no required parameters for Isar
  PatientContactInfoModel({
    this.phone = '',
    this.email,
    this.alternatePhone,
  });

  factory PatientContactInfoModel.fromEntity(dynamic entity) {
    return PatientContactInfoModel(
      phone: entity.phone,
      email: entity.email,
      alternatePhone: entity.alternatePhone,
    );
  }

  dynamic toEntity() {
    return {
      'phone': phone,
      'email': email,
      'alternatePhone': alternatePhone,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
      'alternatePhone': alternatePhone,
    };
  }
}

@embedded
class AddressModel {
  late String street;
  late String city;
  late String state;
  late String country;
  late String postalCode;
  late GeoPointModel? coordinates;

  // Default constructor with no required parameters for Isar
  AddressModel({
    this.street = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.postalCode = '',
    this.coordinates,
  });

  factory AddressModel.fromEntity(dynamic entity) {
    return AddressModel(
      street: entity.street,
      city: entity.city,
      state: entity.state,
      country: entity.country,
      postalCode: entity.postalCode,
      coordinates: entity.coordinates != null ? GeoPointModel.fromEntity(entity.coordinates) : null,
    );
  }

  dynamic toEntity() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'coordinates': coordinates?.toEntity(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'coordinates': coordinates?.toMap(),
    };
  }
}

@embedded
class EmergencyContactModel {
  late String name;
  late String relationship;
  late String phone;

  // Default constructor with no required parameters for Isar
  EmergencyContactModel({
    this.name = '',
    this.relationship = '',
    this.phone = '',
  });

  factory EmergencyContactModel.fromEntity(dynamic entity) {
    return EmergencyContactModel(
      name: entity.name,
      relationship: entity.relationship,
      phone: entity.phone,
    );
  }

  dynamic toEntity() {
    return {
      'name': name,
      'relationship': relationship,
      'phone': phone,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relationship': relationship,
      'phone': phone,
    };
  }
}

@embedded
class InsuranceInfoModel {
  late String provider;
  late String policyNumber;
  late DateTime? expiryDate;

  // Default constructor with no required parameters for Isar
  InsuranceInfoModel({
    this.provider = '',
    this.policyNumber = '',
    this.expiryDate,
  });

  factory InsuranceInfoModel.fromEntity(dynamic entity) {
    return InsuranceInfoModel(
      provider: entity.provider,
      policyNumber: entity.policyNumber,
      expiryDate: entity.expiryDate,
    );
  }

  dynamic toEntity() {
    return {
      'provider': provider,
      'policyNumber': policyNumber,
      'expiryDate': expiryDate,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'provider': provider,
      'policyNumber': policyNumber,
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }
}

@embedded
class GeoPointModel {
  late double latitude;
  late double longitude;

  // Default constructor with no required parameters for Isar
  GeoPointModel({
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  factory GeoPointModel.fromEntity(dynamic entity) {
    return GeoPointModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  dynamic toEntity() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
