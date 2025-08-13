import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/app_routes.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../core/app_strings.dart';
import '../../core/app_values.dart';          // <-- Import AppValues
import '../../core/screen_util_helper.dart';
import '../../widges/rounded_input_field_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.welcomeBack,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: ScreenUtilHelper.fontSize(AppValues.fontSizeXLarge),
                      ),
                    ),
                    SizedBox(height: ScreenUtilHelper.height(AppValues.paddingLarge)),

                    RoundedInputField(
                      controller: emailC,
                      label: AppStrings.email,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || !v.contains('@')) {
                          return AppStrings.enterValidEmail;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: ScreenUtilHelper.height(AppValues.paddingMedium)),

                    RoundedInputField(
                      controller: passC,
                      label: AppStrings.password,
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) {
                        if (v == null || v.length < 6) {
                          return AppStrings.passwordMinChars;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: ScreenUtilHelper.height(AppValues.paddingXLarge)),

                    Obx(() {
                      return authC.isLoading.value
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
                              authC.login(emailC.text.trim(), passC.text.trim());
                            }
                          },
                          child: Text(
                            AppStrings.login,
                            style: AppTextStyles.buttonText.copyWith(
                              fontSize: ScreenUtilHelper.fontSize(AppValues.fontSizeMedium),
                            ),
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: ScreenUtilHelper.height(AppValues.paddingMedium)),

                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.signup),
                      child: Text(
                        AppStrings.createNewAccount,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtilHelper.fontSize(AppValues.fontSizeSmall),
                        ),
                      ),
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
