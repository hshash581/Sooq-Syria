import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<UserModel> getProfile(String userId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(userId)
          .get();

      if (!doc.exists) throw Exception('User not found');
      return UserModel.fromJson(doc.data()!, doc.id);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get profile: ${e.message}');
    }
  }

  Future<UserModel> updateProfile(UserModel user, File? profileImage) async {
    try {
      if (profileImage != null) {
        if (user.profileImage != null) {
          try {
            final oldRef =
                await _firebaseService.storage.refFromURL(user.profileImage!);
            await oldRef.delete();
          } catch (_) {}
        }

        final ref = _firebaseService.storage
            .ref()
            .child('${FirebaseConfig.usersStorage}/${user.id}/profile.jpg');
        await ref.putFile(profileImage);
        final imageUrl = await ref.getDownloadURL();
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

  Future<void> deleteAccount(String userId) async {
    try {
      final userDoc = await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final profileImage = userDoc.data()!['profileImage'] as String?;
        if (profileImage != null) {
          try {
            final ref = await _firebaseService.storage.refFromURL(profileImage);
            await ref.delete();
          } catch (_) {}
        }
      }

      final adsSnapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.adsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      for (final adDoc in adsSnapshot.docs) {
        final images = List<String>.from(adDoc.data()!['images'] as List<dynamic>? ?? []);
        for (final imageUrl in images) {
          try {
            final ref = await _firebaseService.storage.refFromURL(imageUrl);
            await ref.delete();
          } catch (_) {}
        }
        await adDoc.reference.delete();
      }

      final favoritesSnapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.favoritesCollection)
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in favoritesSnapshot.docs) {
        await doc.reference.delete();
      }

      final chatsSnapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .where('buyerId', isEqualTo: userId)
          .get();

      final sellerChatsSnapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.chatsCollection)
          .where('sellerId', isEqualTo: userId)
          .get();

      final allChatDocs = {...chatsSnapshot.docs, ...sellerChatsSnapshot.docs};
      for (final chatDoc in allChatDocs) {
        final messagesSnapshot = await chatDoc.reference
            .collection(FirebaseConfig.messagesCollection)
            .get();
        for (final msgDoc in messagesSnapshot.docs) {
          await msgDoc.reference.delete();
        }
        await chatDoc.reference.delete();
      }

      await _firebaseService.firestore
          .collection(FirebaseConfig.usersCollection)
          .doc(userId)
          .delete();

      final firebaseUser = _firebaseService.auth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.delete();
      }
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete account: ${e.message}');
    }
  }
}
