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
      theme: ThemeData(
          primarySwatch: MaterialColor(
            0xFF0F172A,
            <int, Color>{
              50:  Color(0xFFE3E6EC),
              100: Color(0xFFB9C0CE),
              200: Color(0xFF8A96AE),
              300: Color(0xFF5B6C8E),
              400: Color(0xFF384D75),
              500: Color(0xFF233662), // main color
              600: Color(0xFF0D1425),
              700: Color(0xFF0B111F),
              800: Color(0xFF080E19),
              900: Color(0xFF050A12),
            },
          ),
          primaryColor: Color(0xFF233662),
          elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF233662)),),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarThemeData(backgroundColor: Colors.white),
        inputDecorationTheme: InputDecorationTheme(

          // ---------- TEXT STYLE ----------
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),

          hintStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xFF94A3B8),
          ),

          floatingLabelStyle: const TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.w600,
          ),

          // ---------- FIELD PADDING ----------
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),

          // ---------- DEFAULT BORDER ----------
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),

          // ---------- ENABLED ----------
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),

          // ---------- FOCUSED ----------
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF233662),
              width: 1.8,
            ),
          ),

          // ---------- ERROR ----------
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFEF4444),
              width: 1.5,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFDC2626),
              width: 1.8,
            ),
          ),

          // ---------- FILL ----------
          filled: true,
          fillColor: const Color(0xFFF8FAFC),

          // ---------- ICONS ----------
          prefixIconColor: Color(0xFF64748B),
          suffixIconColor: Color(0xFF64748B),

          // ---------- ERROR STYLE ----------
          errorStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
