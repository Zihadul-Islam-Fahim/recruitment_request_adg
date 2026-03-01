import 'package:get/get.dart';
import 'package:recruitment_request_adg/presentation/controllers/Splash%20Controller.dart';
import 'package:recruitment_request_adg/presentation/controllers/auth_controller.dart';
import 'package:recruitment_request_adg/presentation/controllers/dashboard_controller.dart';
import 'package:recruitment_request_adg/presentation/controllers/delete_account_controller.dart';
import 'package:recruitment_request_adg/presentation/controllers/login_controller.dart';
import 'package:recruitment_request_adg/presentation/controllers/request_controller.dart';

import 'package:recruitment_request_adg/presentation/controllers/signup_controller.dart';


class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.put(AuthController());
    Get.put(LoginController());
    Get.put(SignupController());
    Get.put(DashboardController());
    Get.put(RequestController());
    Get.put(AuthController());
    Get.put(DeleteAccountController());



  }
}