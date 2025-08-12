import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/app_routes.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../core/screen_util_helper.dart';
import '../../widges/rounded_input_field_widgets.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  LoginView({Key? key}) : super(key: key);

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
              horizontal: ScreenUtilHelper.width(32),
              vertical: ScreenUtilHelper.height(40),
            ),
            child: Container(
              padding: EdgeInsets.all(ScreenUtilHelper.width(24)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(16)),
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
                      'Welcome Back',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: ScreenUtilHelper.fontSize(22),
                      ),
                    ),
                    SizedBox(height: ScreenUtilHelper.height(24)),

                    RoundedInputField(
                      controller: emailC,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                      v == null || !v.contains('@') ? 'Enter valid email' : null,
                    ),

                    SizedBox(height: ScreenUtilHelper.height(20)),

                    RoundedInputField(
                      controller: passC,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) =>
                      v == null || v.length < 6 ? 'Min 6 chars' : null,
                    ),

                    SizedBox(height: ScreenUtilHelper.height(32)),

                    Obx(() => authC.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      height: ScreenUtilHelper.height(50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(ScreenUtilHelper.radius(12)),
                          ),
                          elevation: 6,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authC.login(emailC.text.trim(), passC.text.trim());
                          }
                        },
                        child: Text(
                          'Login',
                          style: AppTextStyles.buttonText.copyWith(
                            fontSize: ScreenUtilHelper.fontSize(16),
                          ),
                        ),
                      ),
                    )),

                    SizedBox(height: ScreenUtilHelper.height(16)),

                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.signup),
                      child: Text(
                        'Create new account',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtilHelper.fontSize(14),
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
