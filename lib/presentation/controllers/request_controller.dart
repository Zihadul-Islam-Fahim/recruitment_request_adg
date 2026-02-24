import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:recruitment_request_adg/presentation/controllers/auth_controller.dart';

import '../../data/utils/urls.dart';

class RequestController extends GetxController{
  bool inProgress = false;
  bool hasFile = false;
  File? file;
  String fileName = "";

  Future<void> pickFileDemo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      hasFile = true;
      update();
      file = File(result.files.single.path!);
      fileName = p.basename(file!.path);
      Get.snackbar('File', 'Attached', snackPosition: SnackPosition.BOTTOM);
    } else {
      hasFile = false;
      update();
    }
  }

  Future<bool> sendInfo({
   required String jobTitle,
    required String jobType,

    required String vacancyCount,
    required String urgency,
    required String salaryMin,
    required String salaryMax,
    required String jobLocation,
    required String description,

    required String email,
    required String phone,

})async{

    try{
      inProgress = true;
      update();

      var uri = Uri.parse(Urls.jobPost);
      log(Urls.jobPost);
      var request = http.MultipartRequest('POST', uri);

      final token = AuthController.token;
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Attach fields
      request.fields['job_title'] = jobTitle;
      request.fields['job_type'] = jobType;
      request.fields['job_category'] = email;
      request.fields['vacancy_count'] = vacancyCount;
      request.fields['urgency'] = urgency;
      request.fields['salary_min'] = salaryMin;
      request.fields['salary_max'] = salaryMax;
      request.fields['job_location'] = jobLocation;
      request.fields['description'] = description;
      request.fields['benefits'] = phone;
      request.fields['status'] = 'active';
      request.fields['skills[]'] = 'flutter';
      request.fields['skills[]'] = 'flutter';


      if(hasFile){
        final cvFile = await File(file!.path).readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'attachments',
          cvFile,
          filename: p.basename(file!.path),
        ));
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        inProgress = false;
        update();

        log(response.statusCode.toString());
        log(response.body);
        Get.snackbar('Success', "Apply Successful !!",
            backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      } else {
        log(response.statusCode.toString());
        log(response.body);

        var p = jsonDecode(response.body);


        Get.snackbar('Something went wrong!', 'Try again',
            backgroundColor: Colors.red, colorText: Colors.white);
        inProgress = false;
        update();

        return false;
      }
    } catch (e) {
      log(e.toString());
      inProgress = false;
      update();
      return false;
    }
  }


}