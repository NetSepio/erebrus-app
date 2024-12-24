import 'package:get/get.dart';
import 'package:wire/api/api.dart';
import 'package:wire/view/profile/profile_model.dart';

class ProfileController extends GetxController {
  Rx<ProfileModel> profileModel = ProfileModel().obs;
  RxString mnemonics = "".obs;
  Future getProfile() async {
    profileModel.value = await ApiController().getProfile();
  }
}
