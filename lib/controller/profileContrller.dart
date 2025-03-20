import 'package:erebrus_app/api/api.dart';
import 'package:erebrus_app/view/profile/profile_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rx<ProfileModel> profileModel = ProfileModel().obs;
  RxString mnemonics = "".obs;
  Future getProfile() async {
    profileModel.value = await ApiController().getProfile();
  }
}
