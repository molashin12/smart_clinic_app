import 'package:smart_clinic_app/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  
  Future<UserEntity> signUpWithEmailAndPassword(
    String email, 
    String password, 
    String displayName,
    String role,
  );
  
  Future<void> signOut();
  
  Future<void> resetPassword(String email);
  
  Future<UserEntity?> getCurrentUser();
  
  Future<void> updateUserProfile(UserEntity user);
}
