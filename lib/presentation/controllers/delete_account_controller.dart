import 'package:get/get.dart';
import 'package:recruitment_request_adg/data/models/network_response.dart';
import 'package:recruitment_request_adg/data/services/network_caller.dart';
import 'package:recruitment_request_adg/data/utils/urls.dart';

class DeleteAccountController extends GetxController{
   Future<bool> deleteAccount()async{
    NetworkResponse response = await NetworkCaller().postRequest(Urls.deleteUser);
    if(response.isSuccess){
      Get.snackbar("Account deleted", "Account permanently deleted");
      return true;
    }else{
      Get.snackbar("Failed", "Account deletion failed");
      return false;
    }
   }
}