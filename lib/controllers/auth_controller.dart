import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../core/fire_base_services.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final user = Rxn<UserModel>();
  final isLoading = false.obs;

  UserModel? get currentUser => user.value;

  @override
  void onInit() {
    super.onInit();
    FirebaseService.auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        user.value = null;
        Get.offAllNamed('/login');
      } else {
        final doc = await FirebaseService.firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (doc.exists) {
          user.value = UserModel.fromDoc(doc.id, doc.data()!);
        } else {
          final newUser = UserModel(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
          );
          await FirebaseService.firestore
              .collection('users')
              .doc(firebaseUser.uid)
              .set(newUser.toMap());
          user.value = newUser;
        }
        Get.offAllNamed('/home');
      }
    });
  }

  Future<void> signup(
      String name, String email, String password, File? profileImageFile) async {
    try {
      isLoading.value = true;

      final cred = await FirebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = cred.user!.uid;
      await cred.user!.updateDisplayName(name);
      await cred.user!.reload();

      String? profileImageUrl;
      if (profileImageFile != null) {
        final ref = FirebaseService.storage
            .ref()
            .child('profile_images')
            .child('$uid.jpg');
        await ref.putFile(profileImageFile);
        profileImageUrl = await ref.getDownloadURL();
      }

      final userModel = UserModel(
        id: uid,
        name: name,
        email: email,
        profileImage: profileImageUrl,
      );

      await FirebaseService.firestore
          .collection('users')
          .doc(uid)
          .set(userModel.toMap());

      user.value = userModel;

      Get.offAllNamed('/home');

      Get.snackbar(
        'Success',
        'Account created successfully!',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Signup Failed',
        e.toString(),
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final cred = await FirebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);

      final firebaseUser = cred.user;
      if (firebaseUser == null) throw Exception('User is null after login');

      final doc = await FirebaseService.firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) {
        final newUser = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
        );
        await FirebaseService.firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(newUser.toMap());
        user.value = newUser;
      } else {
        user.value = UserModel.fromDoc(doc.id, doc.data()!);
      }

      Get.offAllNamed('/home');

      // Success Snackbar
      Get.snackbar(
        'Welcome',
        'Login successful!',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String name,
    File? newImage,
  }) async {
    try {
      isLoading.value = true;
      final uid = currentUser?.id;
      if (uid == null) return;

      String? imageUrl = currentUser?.profileImage;

      if (newImage != null) {
        final ref = FirebaseService.storage
            .ref()
            .child('profile_images')
            .child('$uid.jpg');

        await ref.putFile(newImage);
        imageUrl = await ref.getDownloadURL();
      }

      final updatedData = {
        'name': name,
        'profileImage': imageUrl,
      };

      await FirebaseService.firestore
          .collection('users')
          .doc(uid)
          .update(updatedData);

      user.value = UserModel(
        id: uid,
        name: name,
        email: currentUser!.email,
        profileImage: imageUrl,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await FirebaseService.auth.signOut();
  }
}
