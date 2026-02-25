import 'dart:developer';

import 'package:get/get.dart';
import 'package:recruitment_request_adg/data/models/job_post_list_model.dart';
import 'package:recruitment_request_adg/data/models/network_response.dart';
import 'package:recruitment_request_adg/data/services/network_caller.dart';

import '../../data/utils/urls.dart';

class DashboardController extends GetxController{
  bool inProgress = false;
   JobPostListModel? jobPostListModel;

  Future<void> getPosts ()async{
    inProgress = true;
    update();
  
    NetworkResponse response = await NetworkCaller().getRequest(Urls.jobGet);
    
    if(response.isSuccess) {
      jobPostListModel = JobPostListModel.fromJson(response.responseData);
    }
    
    log(jobPostListModel!.jobPostList!.length.toString());
    
    inProgress= false;
    update();


  }



}