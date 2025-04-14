import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_clinic_app/domain/entities/user_entity.dart';
import 'package:smart_clinic_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<UserEntity?> get authStateChanges => 
    _firebaseAuth.authStateChanges().map((User? user) {
      if (user == null) {
        return null;
      }
      return UserEntity(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        photoURL: user.photoURL,
      );
    });

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw Exception('Authentication failed');
      }
      
      // Update last login timestamp
      await _firestore.collection('users').doc(userCredential.user!.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
      
      return UserEntity(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        displayName: userCredential.user!.displayName,
        phoneNumber: userCredential.user!.phoneNumber,
        photoURL: userCredential.user!.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String email, 
    String password, 
    String displayName,
    String role,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw Exception('User creation failed');
      }
      
      // Update user profile
      await userCredential.user!.updateDisplayName(displayName);
      
      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'displayName': displayName,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'isActive': true,
        'subscriptionTier': 'free',
        'preferredLanguage': 'en',
        'notificationSettings': {
          'email': true,
          'sms': true,
          'push': true,
        },
      });
      
      return UserEntity(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        displayName: displayName,
        phoneNumber: userCredential.user!.phoneNumber,
        photoURL: userCredential.user!.photoURL,
        role: role,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    
    // Get additional user data from Firestore
    final userData = await _firestore.collection('users').doc(user.uid).get();
    
    return UserEntity(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      role: userData.data()?['role'],
      clinicAccess: List<String>.from(userData.data()?['clinicAccess'] ?? []),
      subscriptionTier: userData.data()?['subscriptionTier'],
    );
  }

  @override
  Future<void> updateUserProfile(UserEntity user) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }
      
      // Update Auth profile
      if (user.displayName != null && user.displayName != currentUser.displayName) {
        await currentUser.updateDisplayName(user.displayName);
      }
      
      if (user.photoURL != null && user.photoURL != currentUser.photoURL) {
        await currentUser.updatePhotoURL(user.photoURL);
      }
      
      // Update Firestore document
      await _firestore.collection('users').doc(currentUser.uid).update({
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'phoneNumber': user.phoneNumber,
        'preferredLanguage': user.preferredLanguage,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email');
      case 'wrong-password':
        return Exception('Incorrect password');
      case 'email-already-in-use':
        return Exception('Email is already in use');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-email':
        return Exception('Invalid email format');
      default:
        return Exception('Authentication error: ${e.message}');
    }
  }
}
