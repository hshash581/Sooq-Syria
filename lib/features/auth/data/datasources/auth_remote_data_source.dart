import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../data/models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<String> signInWithPhone(String phoneNumber) async {
    try {
      await _firebaseService.auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          throw e;
        },
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return '';
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> verifyOtp(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _firebaseService.auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('Failed to sign in');

      final userDoc = await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!, userDoc.id);
      }

      final newUser = UserModel(
        id: firebaseUser.uid,
        fullName: '',
        phoneNumber: firebaseUser.phoneNumber ?? '',
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
      );
      await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(firebaseUser.uid)
          .set(newUser.toJson());
      return newUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> signUp(UserModel user, File? profileImage) async {
    try {
      if (profileImage != null) {
        final imageUrl = await _uploadProfileImage(profileImage, user.id);
        user = user.copyWith(profileImage: imageUrl);
      }

      await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));

      return user;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create user: ${e.message}');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseService.auth.currentUser;
      if (firebaseUser == null) return null;

      final userDoc = await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) return null;
      return UserModel.fromJson(userDoc.data()!, userDoc.id);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get current user: ${e.message}');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseService.auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> updateProfile(UserModel user, File? profileImage) async {
    try {
      if (profileImage != null) {
        final imageUrl = await _uploadProfileImage(profileImage, user.id);
        user = user.copyWith(profileImage: imageUrl);
      }

      await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(user.id)
          .update(user.copyWith(lastSeen: DateTime.now()).toJson());

      return user;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }

  Future<void> updateFcmToken(String token) async {
    try {
      final firebaseUser = _firebaseService.auth.currentUser;
      if (firebaseUser == null) return;

      await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(firebaseUser.uid)
          .update({'fcmToken': token, 'lastSeen': Timestamp.fromDate(DateTime.now())});
    } on FirebaseException catch (e) {
      throw Exception('Failed to update FCM token: ${e.message}');
    }
  }

  Future<String> _uploadProfileImage(File image, String userId) async {
    try {
      final ref = _firebaseService.storage
          .ref()
          .child('${FirebaseConfig.usersStorage}/$userId/profile.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Failed to upload image: ${e.message}');
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return 'رمز التحقق غير صحيح';
      case 'too-many-requests':
        return 'طلبات كثيرة جداً، حاول لاحقاً';
      case 'invalid-phone-number':
        return 'رقم الهاتف غير صحيح';
      default:
        return e.message ?? 'حدث خطأ أثناء تسجيل الدخول';
    }
  }
}
