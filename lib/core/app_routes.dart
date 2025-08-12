import 'package:get/get.dart';
import '../views/auth/login_view.dart';
import '../views/auth/sign_up_view.dart';
import '../views/home/home_shell.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';

  static final routes = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signup, page: () => SignupView()),
    GetPage(name: home, page: () => HomeShell()),
  ];
}
