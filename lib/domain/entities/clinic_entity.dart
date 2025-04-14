class ClinicEntity {
  final String? id;
  final String name;
  final Address address;
  final ContactInfo contactInfo;
  final String ownerId;
  final String? logo;
  final Map<String, BusinessHours> businessHours;
  final AppointmentSettings appointmentSettings;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String timezone;
  final String currency;
  final Branding? branding;

  ClinicEntity({
    this.id,
    required this.name,
    required this.address,
    required this.contactInfo,
    required this.ownerId,
    this.logo,
    required this.businessHours,
    required this.appointmentSettings,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
    required this.timezone,
    required this.currency,
    this.branding,
  });

  ClinicEntity copyWith({
    String? id,
    String? name,
    Address? address,
    ContactInfo? contactInfo,
    String? ownerId,
    String? logo,
    Map<String, BusinessHours>? businessHours,
    AppointmentSettings? appointmentSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? timezone,
    String? currency,
    Branding? branding,
  }) {
    return ClinicEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      contactInfo: contactInfo ?? this.contactInfo,
      ownerId: ownerId ?? this.ownerId,
      logo: logo ?? this.logo,
      businessHours: businessHours ?? this.businessHours,
      appointmentSettings: appointmentSettings ?? this.appointmentSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
      branding: branding ?? this.branding,
    );
  }

  factory ClinicEntity.fromMap(Map<String, dynamic> map, String docId) {
    final businessHoursMap = map['businessHours'] as Map<String, dynamic>;
    final businessHours = businessHoursMap.map(
      (key, value) => MapEntry(key, BusinessHours.fromMap(value as Map<String, dynamic>)),
    );

    return ClinicEntity(
      id: docId,
      name: map['name'] ?? '',
      address: Address.fromMap(map['address'] as Map<String, dynamic>),
      contactInfo: ContactInfo.fromMap(map['contactInfo'] as Map<String, dynamic>),
      ownerId: map['ownerId'] ?? '',
      logo: map['logo'],
      businessHours: businessHours,
      appointmentSettings: AppointmentSettings.fromMap(map['appointmentSettings'] as Map<String, dynamic>),
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      isActive: map['isActive'] ?? true,
      timezone: map['timezone'] ?? 'UTC',
      currency: map['currency'] ?? 'USD',
      branding: map['branding'] != null ? Branding.fromMap(map['branding'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address.toMap(),
      'contactInfo': contactInfo.toMap(),
      'ownerId': ownerId,
      'logo': logo,
      'businessHours': businessHours.map((key, value) => MapEntry(key, value.toMap())),
      'appointmentSettings': appointmentSettings.toMap(),
      'isActive': isActive,
      'timezone': timezone,
      'currency': currency,
      'branding': branding?.toMap(),
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

class ContactInfo {
  final String phone;
  final String email;
  final String? website;

  ContactInfo({
    required this.phone,
    required this.email,
    this.website,
  });

  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      website: map['website'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
    };
  }
}

class BusinessHours {
  final String start;
  final String end;
  final bool closed;

  BusinessHours({
    required this.start,
    required this.end,
    this.closed = false,
  });

  factory BusinessHours.fromMap(Map<String, dynamic> map) {
    return BusinessHours(
      start: map['start'] ?? '09:00',
      end: map['end'] ?? '17:00',
      closed: map['closed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
      'closed': closed,
    };
  }
}

class AppointmentSettings {
  final int defaultDuration;
  final int bufferTime;
  final int? maxDailyAppointments;

  AppointmentSettings({
    required this.defaultDuration,
    required this.bufferTime,
    this.maxDailyAppointments,
  });

  factory AppointmentSettings.fromMap(Map<String, dynamic> map) {
    return AppointmentSettings(
      defaultDuration: map['defaultDuration'] ?? 30,
      bufferTime: map['bufferTime'] ?? 5,
      maxDailyAppointments: map['maxDailyAppointments'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'defaultDuration': defaultDuration,
      'bufferTime': bufferTime,
      'maxDailyAppointments': maxDailyAppointments,
    };
  }
}

class Branding {
  final String? primaryColor;
  final String? secondaryColor;
  final String? accentColor;
  final String? fontFamily;

  Branding({
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
    this.fontFamily,
  });

  factory Branding.fromMap(Map<String, dynamic> map) {
    return Branding(
      primaryColor: map['primaryColor'],
      secondaryColor: map['secondaryColor'],
      accentColor: map['accentColor'],
      fontFamily: map['fontFamily'],
    );
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
