import 'package:cloud_firestore/cloud_firestore.dart';

class PatientEntity {
  final String? id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final PatientContactInfo contactInfo;
  final Address address;
  final EmergencyContact emergencyContact;
  final InsuranceInfo? insuranceInfo;
  final List<String> allergies;
  final String? bloodType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String primaryDoctorId;
  final String primaryClinicId;
  final String? profilePhoto;
  final String? notes;
  final bool isActive;

  PatientEntity({
    this.id,
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
  });

  String get fullName => '$firstName $lastName';
  
  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month || 
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  PatientEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    PatientContactInfo? contactInfo,
    Address? address,
    EmergencyContact? emergencyContact,
    InsuranceInfo? insuranceInfo,
    List<String>? allergies,
    String? bloodType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? primaryDoctorId,
    String? primaryClinicId,
    String? profilePhoto,
    String? notes,
    bool? isActive,
  }) {
    return PatientEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      contactInfo: contactInfo ?? this.contactInfo,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      insuranceInfo: insuranceInfo ?? this.insuranceInfo,
      allergies: allergies ?? this.allergies,
      bloodType: bloodType ?? this.bloodType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      primaryDoctorId: primaryDoctorId ?? this.primaryDoctorId,
      primaryClinicId: primaryClinicId ?? this.primaryClinicId,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }

  factory PatientEntity.fromMap(Map<String, dynamic> map, String docId) {
    return PatientEntity(
      id: docId,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      dateOfBirth: map['dateOfBirth'] != null 
          ? (map['dateOfBirth'] as Timestamp).toDate() 
          : DateTime.now(),
      gender: map['gender'] ?? 'other',
      contactInfo: PatientContactInfo.fromMap(map['contactInfo'] as Map<String, dynamic>),
      address: Address.fromMap(map['address'] as Map<String, dynamic>),
      emergencyContact: EmergencyContact.fromMap(map['emergencyContact'] as Map<String, dynamic>),
      insuranceInfo: map['insuranceInfo'] != null 
          ? InsuranceInfo.fromMap(map['insuranceInfo'] as Map<String, dynamic>) 
          : null,
      allergies: map['allergies'] != null 
          ? List<String>.from(map['allergies']) 
          : [],
      bloodType: map['bloodType'],
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      primaryDoctorId: map['primaryDoctorId'] ?? '',
      primaryClinicId: map['primaryClinicId'] ?? '',
      profilePhoto: map['profilePhoto'],
      notes: map['notes'],
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
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
    };
  }
}

class PatientContactInfo {
  final String phone;
  final String? email;
  final String? alternatePhone;

  PatientContactInfo({
    required this.phone,
    this.email,
    this.alternatePhone,
  });

  factory PatientContactInfo.fromMap(Map<String, dynamic> map) {
    return PatientContactInfo(
      phone: map['phone'] ?? '',
      email: map['email'],
      alternatePhone: map['alternatePhone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
      'alternatePhone': alternatePhone,
    };
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final GeoPoint? coordinates;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.coordinates,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      postalCode: map['postalCode'] ?? '',
      coordinates: map['coordinates'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'coordinates': coordinates,
    };
  }
}

class EmergencyContact {
  final String name;
  final String relationship;
  final String phone;

  EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relationship': relationship,
      'phone': phone,
    };
  }
}

class InsuranceInfo {
  final String provider;
  final String policyNumber;
  final DateTime? expiryDate;

  InsuranceInfo({
    required this.provider,
    required this.policyNumber,
    this.expiryDate,
  });

  factory InsuranceInfo.fromMap(Map<String, dynamic> map) {
    return InsuranceInfo(
      provider: map['provider'] ?? '',
      policyNumber: map['policyNumber'] ?? '',
      expiryDate: map['expiryDate'] != null 
          ? (map['expiryDate'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'provider': provider,
      'policyNumber': policyNumber,
      'expiryDate': expiryDate,
    };
  }
}

class GeoPoint {
  final double latitude;
  final double longitude;

  GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory GeoPoint.fromMap(Map<String, dynamic> map) {
    return GeoPoint(
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
    );
  }
}
