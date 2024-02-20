import 'package:get/get.dart';
import 'package:wire/api/api.dart';
import 'package:wire/view/profile/profile_model.dart';

class HomeController extends GetxController {
  RxString? collectionId;
  RxInt selectedNFT = 0.obs;
  Rx<ProfileModel>? profileModel;
  RxBool isLoading = true.obs;

  getProfileData() async {
    try {
      ProfileModel? result = await ApiController().getProfile();
      isLoading.value = false;
      profileModel = Rx<ProfileModel>(result);
      update();
    } catch (e) {
      isLoading.value = false;
    }
  }
}
