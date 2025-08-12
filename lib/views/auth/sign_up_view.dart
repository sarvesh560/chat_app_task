import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../core/screen_util_helper.dart';
import '../../widges/rounded_input_field_widgets.dart';

class SignupView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);

  SignupView({Key? key}) : super(key: key);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {

    final authC = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        width: ScreenUtilHelper.width(ScreenUtilHelper.screenWidth),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtilHelper.width(32),
              vertical: ScreenUtilHelper.height(40),
            ),
            child: Container(
              padding: EdgeInsets.all(ScreenUtilHelper.width(24)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: ScreenUtilHelper.height(12),
                    offset: Offset(0, ScreenUtilHelper.height(6)),
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Create Account', style: AppTextStyles.titleLarge),
                    SizedBox(height: ScreenUtilHelper.height(24)),

                    Obx(() => GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: ScreenUtilHelper.radius(45),
                        backgroundColor: Colors.grey[300],
                        backgroundImage: selectedImage.value != null
                            ? FileImage(selectedImage.value!)
                            : null,
                        child: selectedImage.value == null
                            ? Icon(Icons.camera_alt,
                            size: ScreenUtilHelper.fontSize(40),
                            color: Colors.grey)
                            : null,
                      ),
                    )),
                    SizedBox(height: ScreenUtilHelper.height(24)),

                    RoundedInputField(
                      controller: nameC,
                      label: 'Name',
                      icon: Icons.person_outline,
                      validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                    ),
                    SizedBox(height: ScreenUtilHelper.height(16)),

                    RoundedInputField(
                      controller: emailC,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter email';
                        if (!GetUtils.isEmail(v)) return 'Enter valid email';
                        return null;
                      },
                    ),
                    SizedBox(height: ScreenUtilHelper.height(16)),

                    RoundedInputField(
                      controller: passC,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
                    ),
                    SizedBox(height: ScreenUtilHelper.height(32)),

                    Obx(() => authC.isLoading.value
                        ? CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      height: ScreenUtilHelper.height(50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(12)),
                          ),
                          elevation: 6,
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authC.signup(
                              nameC.text.trim(),
                              emailC.text.trim(),
                              passC.text.trim(),
                              selectedImage.value,
                            );
                          }
                        },
                        child: Text('Sign Up', style: AppTextStyles.buttonText),
                      ),
                    )),

                    SizedBox(height: ScreenUtilHelper.height(16)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
