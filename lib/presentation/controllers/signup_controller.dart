import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/userModel.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../screens/login_screen.dart';
import 'auth_controller.dart';

class SignupController extends GetxController{


  late final TextEditingController nameCtrl;
  late final TextEditingController companyCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController passwordCtrl;


  @override
  void onInit() {
    super.onInit();
    nameCtrl = TextEditingController();
    companyCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    companyCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  bool passwordVisible = false;
  // bool submitting = false;

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    update();
  }


  String? validateName(String? v) {
    if (v == null || v.trim().length < 2) return 'Enter your full name';
    return null;
  }

  String? validateCompany(String? v) {
    if (v == null || v.trim().isEmpty) return 'Company name required';
    return null;
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email required';
    if (!v.contains('@') || v.trim().length < 5) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }



  bool inProgress = false;
  UserModel userModel =UserModel();

  Future<bool> signup() async {
    inProgress =true;
    update();

    Map<String,dynamic> inputParams ={
      "name" : nameCtrl.text,
      "company_name" : companyCtrl.text,
      "email": emailCtrl.text,
      'password':passwordCtrl.text
    };
    try{
      final NetworkResponse response = await NetworkCaller().postRequest(
          Urls.register, body: inputParams);
      if (response.isSuccess) {

        String token = response.responseData["token"].toString();
        userModel = UserModel.fromJson(response.responseData);
        await AuthController().saveUserInformation(token, userModel);

        inProgress = false;
        update();
        return true;
      } else {

        Get.snackbar(
            response.responseData["message"].toString(), "Try again", backgroundColor: Colors.red,
            colorText: Colors.white);
        inProgress = false;
        update();
        return false;
      }
    }catch(e){
      log(e.toString());
      Get.snackbar('Something went wrong!',e.toString(),backgroundColor: Colors.red,colorText: Colors.white);
      inProgress = false;
      update();
      return false;
    }


    }

}