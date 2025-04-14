import 'package:isar/isar.dart';
import 'package:smart_clinic_app/domain/entities/clinic_entity.dart';
import 'dart:convert';

part 'clinic_model.g.dart';

@collection
class ClinicModel {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String? firebaseId;
  
  late String name;
  late AddressModel address;
  late ContactInfoModel contactInfo;
  late String ownerId;
  late String? logo;
  
  // Isar doesn't support Map<String, Object> directly, so we'll store as JSON string
  @ignore
  Map<String, BusinessHoursModel> businessHours = {};
  
  // Store business hours as a JSON string
  late String businessHoursJson;
  
  late AppointmentSettingsModel appointmentSettings;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late bool isActive;
  late String timezone;
  late String currency;
  late BrandingModel? branding;
  late DateTime? lastSynced;
  late bool needsSync;

  // Constructor
  ClinicModel({
    this.firebaseId,
    required this.name,
    required this.address,
    required this.contactInfo,
    required this.ownerId,
    this.logo,
    Map<String, BusinessHoursModel>? businessHours,
    required this.appointmentSettings,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
    required this.timezone,
    required this.currency,
    this.branding,
    this.lastSynced,
    this.needsSync = false,
  }) {
    this.businessHours = businessHours ?? {};
    // Convert business hours to JSON string
    final Map<String, Map<String, dynamic>> businessHoursMap = {};
    this.businessHours.forEach((key, value) {
      businessHoursMap[key] = value.toMap();
    });
    businessHoursJson = jsonEncode(businessHoursMap);
  }

  // Convert from Entity to Model
  factory ClinicModel.fromEntity(ClinicEntity entity) {
    final businessHoursMap = <String, BusinessHoursModel>{};
    if (entity.businessHours is Map<String, dynamic>) {
      (entity.businessHours as Map<String, dynamic>).forEach((key, value) {
        businessHoursMap[key] = BusinessHoursModel.fromEntity(value);
      });
    }

    return ClinicModel(
      firebaseId: entity.id,
      name: entity.name,
      address: AddressModel.fromEntity(entity.address),
      contactInfo: ContactInfoModel.fromEntity(entity.contactInfo),
      ownerId: entity.ownerId,
      logo: entity.logo,
      businessHours: businessHoursMap,
      appointmentSettings: AppointmentSettingsModel.fromEntity(entity.appointmentSettings),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isActive: entity.isActive,
      timezone: entity.timezone,
      currency: entity.currency,
      branding: entity.branding != null ? BrandingModel.fromEntity(entity.branding!) : null,
      lastSynced: DateTime.now(),
      needsSync: false,
    );
  }

  // Convert to Entity
  ClinicEntity toEntity() {
    final Map<String, dynamic> businessHoursMap = {};
    businessHours.forEach((key, value) {
      businessHoursMap[key] = value.toEntity();
    });

    return ClinicEntity(
      id: firebaseId,
      name: name,
      address: address.toEntity(),
      contactInfo: contactInfo.toEntity(),
      ownerId: ownerId,
      logo: logo,
      businessHours: businessHoursMap,
      appointmentSettings: appointmentSettings.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
      timezone: timezone,
      currency: currency,
      branding: branding?.toEntity(),
    );
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> businessHoursMap = {};
    businessHours.forEach((key, value) {
      businessHoursMap[key] = value.toMap();
    });

    return {
      'name': name,
      'address': address.toMap(),
      'contactInfo': contactInfo.toMap(),
      'ownerId': ownerId,
      'logo': logo,
      'businessHours': businessHoursMap,
      'appointmentSettings': appointmentSettings.toMap(),
      'isActive': isActive,
      'timezone': timezone,
      'currency': currency,
      'branding': branding?.toMap(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
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
class ContactInfoModel {
  late String phone;
  late String email;
  late String? website;

  // Default constructor with no required parameters for Isar
  ContactInfoModel({
    this.phone = '',
    this.email = '',
    this.website,
  });

  factory ContactInfoModel.fromEntity(dynamic entity) {
    return ContactInfoModel(
      phone: entity.phone,
      email: entity.email,
      website: entity.website,
    );
  }

  dynamic toEntity() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
    };
  }
}

@embedded
class BusinessHoursModel {
  late String start;
  late String end;
  late bool closed;

  // Default constructor with no required parameters for Isar
  BusinessHoursModel({
    this.start = '09:00',
    this.end = '17:00',
    this.closed = false,
  });

  factory BusinessHoursModel.fromEntity(dynamic entity) {
    return BusinessHoursModel(
      start: entity.start ?? '09:00',
      end: entity.end ?? '17:00',
      closed: entity.closed ?? false,
    );
  }

  dynamic toEntity() {
    return {
      'start': start,
      'end': end,
      'closed': closed,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
      'closed': closed,
    };
  }
}

@embedded
class AppointmentSettingsModel {
  late int defaultDuration;
  late int bufferTime;
  late int? maxDailyAppointments;

  // Default constructor with no required parameters for Isar
  AppointmentSettingsModel({
    this.defaultDuration = 30,
    this.bufferTime = 5,
    this.maxDailyAppointments,
  });

  factory AppointmentSettingsModel.fromEntity(dynamic entity) {
    return AppointmentSettingsModel(
      defaultDuration: entity.defaultDuration,
      bufferTime: entity.bufferTime,
      maxDailyAppointments: entity.maxDailyAppointments,
    );
  }

  dynamic toEntity() {
    return {
      'defaultDuration': defaultDuration,
      'bufferTime': bufferTime,
      'maxDailyAppointments': maxDailyAppointments,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'defaultDuration': defaultDuration,
      'bufferTime': bufferTime,
      'maxDailyAppointments': maxDailyAppointments,
    };
  }
}

@embedded
class BrandingModel {
  late String? primaryColor;
  late String? secondaryColor;
  late String? accentColor;
  late String? fontFamily;

  // Default constructor with no required parameters for Isar
  BrandingModel({
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
    this.fontFamily,
  });

  factory BrandingModel.fromEntity(dynamic entity) {
    return BrandingModel(
      primaryColor: entity.primaryColor,
      secondaryColor: entity.secondaryColor,
      accentColor: entity.accentColor,
      fontFamily: entity.fontFamily,
    );
  }

  dynamic toEntity() {
    return {
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'accentColor': accentColor,
      'fontFamily': fontFamily,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'accentColor': accentColor,
      'fontFamily': fontFamily,
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
