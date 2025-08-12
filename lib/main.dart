import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/app_routes.dart';
import 'controllers/auth_controller.dart';
import 'core/fire_base_services.dart';
import 'core/screen_util_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtilHelper.init(context);

    return GetMaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
    );
  }
}
