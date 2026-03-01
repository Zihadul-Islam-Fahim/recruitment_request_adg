import 'package:get/get.dart';
import 'package:recruitment_request_adg/presentation/controllers/auth_controller.dart';
import 'package:recruitment_request_adg/presentation/screens/login_screen.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _goNext();
  }
  

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if(await AuthController().checkAuthState()){
      Get.offAllNamed('/dashboard');
    }else{
      Get.offAllNamed('/onboarding');
    }
    // Navigate to dashboard
    
  }
}