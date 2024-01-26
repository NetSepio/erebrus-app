import 'package:get/get.dart';
import 'package:wire/api/api.dart';
import 'package:wire/view/profile/profile_model.dart';

class HomeController extends GetxController {
  RxString? collectionId;
  RxInt selectedNFT = 0.obs;
  Rx<ProfileModel>? profileModel;

  getProfileData() async {
    ProfileModel? result = await ApiController().getProfile();
    profileModel = Rx<ProfileModel>(result);
  }
}
