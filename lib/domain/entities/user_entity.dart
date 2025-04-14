class UserEntity {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;
  final String? role;
  final List<String>? clinicAccess;
  final String? subscriptionTier;
  final String? preferredLanguage;

  UserEntity({
    this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    this.role,
    this.clinicAccess,
    this.subscriptionTier,
    this.preferredLanguage,
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    String? role,
    List<String>? clinicAccess,
    String? subscriptionTier,
    String? preferredLanguage,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      clinicAccess: clinicAccess ?? this.clinicAccess,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }

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

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      phoneNumber: map['phoneNumber'],
      photoURL: map['photoURL'],
      role: map['role'],
      clinicAccess: map['clinicAccess'] != null 
          ? List<String>.from(map['clinicAccess']) 
          : null,
      subscriptionTier: map['subscriptionTier'],
      preferredLanguage: map['preferredLanguage'],
    );
  }

  @override
  String toString() {
    return 'UserEntity(uid: $uid, email: $email, displayName: $displayName, role: $role)';
  }
}
