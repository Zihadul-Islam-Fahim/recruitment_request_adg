import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recruitment_request_adg/presentation/controllers/adg_controller.dart';
import 'package:recruitment_request_adg/presentation/screens/dashboard_screen.dart';
import 'package:recruitment_request_adg/presentation/screens/login_screen.dart';
import 'package:recruitment_request_adg/presentation/screens/new_request_screen.dart';
import 'package:recruitment_request_adg/presentation/screens/register_screen.dart';
import 'package:recruitment_request_adg/presentation/screens/request_details_screen.dart';
import 'package:recruitment_request_adg/presentation/screens/splash_screen.dart';

import 'controller_binder.dart';

void main() {
  // register controller globally
  Get.put(ADGController());
  runApp(const ADGApp());
}

class ADGApp extends StatelessWidget {
  const ADGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Recruitment Request ADG',
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinder(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () =>  SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/register', page: () =>  RegisterScreen()),
        GetPage(name: '/new_request', page: () => const NewRequestScreen()),
        GetPage(name: '/detail/:id', page: () => const RequestDetailScreen()),
      ],
      theme: ThemeData(primarySwatch: Colors.indigo,elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent)
      )),
    );
  }
}
