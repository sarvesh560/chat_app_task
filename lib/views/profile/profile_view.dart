import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../core/screen_util_helper.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final authC = Get.find<AuthController>();
  final Rx<File?> newImage = Rx<File?>(null);
  final TextEditingController nameController = TextEditingController();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      newImage.value = File(pickedFile.path);
      await _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    final user = authC.currentUser;

    if (user != null) {
      await authC.updateProfile(
        name: nameController.text.trim().isEmpty
            ? user.name
            : nameController.text.trim(),
        newImage: newImage.value,
      );
      Get.snackbar("Success", "Profile updated",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: AppTextStyles.titleLarge.copyWith(
            fontSize: ScreenUtilHelper.fontSize(18),
          ),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.logout,
                color: AppColors.card,
                size: ScreenUtilHelper.fontSize(22)),
            onPressed: authC.signOut,
          ),
        ],
      ),
      body: Obx(() {
        final user = authC.user.value;

        if (user == null) {
          return Center(
            child: Text(
              'No user logged in',
              style: AppTextStyles.bodyText2.copyWith(
                fontSize: ScreenUtilHelper.fontSize(16),
              ),
            ),
          );
        }

        nameController.text = user.name;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtilHelper.width(24),
            vertical: ScreenUtilHelper.height(32),
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(24)),
            ),
            elevation: ScreenUtilHelper.height(8),
            shadowColor: AppColors.primary.withOpacity(0.3),
            child: Padding(
              padding: EdgeInsets.all(ScreenUtilHelper.width(28)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Obx(() => CircleAvatar(
                        radius: ScreenUtilHelper.radius(65),
                        backgroundColor: AppColors.deepPurpleLight,
                        backgroundImage: newImage.value != null
                            ? FileImage(newImage.value!)
                            : (user.profileImage != null
                            ? NetworkImage(user.profileImage!)
                            : null)
                        as ImageProvider<Object>?,
                        child: (newImage.value == null &&
                            user.profileImage == null)
                            ? Icon(
                          Icons.person,
                          size: ScreenUtilHelper.fontSize(70),
                          color: AppColors.primary,
                        )
                            : null,
                      )),
                      Positioned(
                        bottom: 0,
                        right: ScreenUtilHelper.width(4),
                        child: GestureDetector(
                          onTap: pickImage,
                          child: CircleAvatar(
                            radius: ScreenUtilHelper.radius(22),
                            backgroundColor: AppColors.primary,
                            child: Icon(Icons.camera_alt,
                                size: ScreenUtilHelper.fontSize(22),
                                color: AppColors.card),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: ScreenUtilHelper.height(30)),
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontSize: ScreenUtilHelper.fontSize(24),
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Your Name',
                      hintStyle: AppTextStyles.bodyText2.copyWith(
                        fontSize: ScreenUtilHelper.fontSize(18),
                      ),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear,
                            color: Colors.grey,
                            size: ScreenUtilHelper.fontSize(20)),
                        onPressed: () => nameController.clear(),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtilHelper.height(12)),
                  Text(
                    user.email,
                    style: AppTextStyles.bodyText2.copyWith(
                      fontSize: ScreenUtilHelper.fontSize(16),
                      color: AppColors.primary.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
