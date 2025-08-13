import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../core/app_strings.dart';
import '../../core/app_values.dart';
import '../../core/screen_util_helper.dart';
import '../../widges/rounded_input_field_widgets.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
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
              horizontal: ScreenUtilHelper.width(AppValues.paddingXLarge),
              vertical: ScreenUtilHelper.height(AppValues.paddingXLarge),
            ),
            child: Container(
              padding: EdgeInsets.all(ScreenUtilHelper.width(AppValues.paddingLarge)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(AppValues.borderRadiusLarge)),
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
                    Text(AppStrings.createAccount, style: AppTextStyles.titleLarge),
                    SizedBox(height: ScreenUtilHelper.height(AppValues.paddingLarge)),

                    Obx(() => GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: ScreenUtilHelper.radius(AppValues.avatarRadius),
                        backgroundColor: Colors.grey[300],
                        backgroundImage: selectedImage.value != null
                            ? FileImage(selectedImage.value!)
                            : null,
                        child: selectedImage.value == null
                            ? Icon(
                          Icons.camera_alt,
                          size: ScreenUtilHelper.fontSize(AppValues.fontSizeXXLarge),
                          color: Colors.grey,
                        )
                            : null,
                      ),
                    )),
                    SizedBox(height: ScreenUtilHelper.height(AppValues.paddingLarge)),

                    RoundedInputField(
                      controller: nameC,
                      label: AppStrings.name,
                      icon: Icons.person_outline,
                      validator: (v) => v == null || v.isEmpty ? AppStrings.enterName : null,
                    ),
                    SizedBox(height: ScreenUtilHelper.height(AppValues.paddingMedium)),

                    RoundedInputField(
                      controller: emailC,
                      label: AppStrings.email,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return AppStrings.enterEmail;
                        if (!GetUtils.isEmail(v)) return AppStrings.enterValidSignupEmail;
                        return null;
                      },
                    ),
                    SizedBox(height: ScreenUtilHelper.height(AppValues.paddingMedium)),

                    RoundedInputField(
                      controller: passC,
                      label: AppStrings.password,
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) => v == null || v.length < 6 ? AppStrings.enterPassword : null,
                    ),
                    SizedBox(height: ScreenUtilHelper.height(AppValues.paddingXLarge)),

                    Obx(() => authC.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      height: ScreenUtilHelper.height(AppValues.buttonHeight),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(AppValues.borderRadiusMedium)),
                          ),
                          elevation: AppValues.buttonElevation,
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
                        child: Text(AppStrings.signUp, style: AppTextStyles.buttonText),
                      ),
                    )),

                    SizedBox(height: ScreenUtilHelper.height(AppValues.paddingMedium)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyHaveAccount,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Text(
                            AppStrings.signIn,
                            style: const TextStyle(
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
