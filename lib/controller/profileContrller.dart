import 'package:erebrus_app/api/api.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/secure_storage.dart';
import 'package:erebrus_app/view/profile/profile_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final storage = SecureStorage();
  Rx<ProfileModel> profileModel = ProfileModel().obs;
  RxString mnemonics = "".obs;
  Future getProfile() async {
    mnemonics.value = await storage.getStoredValue("mnemonic") ?? "";
    profileModel.value = await ApiController().getProfile();
    if (profileModel.value.payload!.referralCode != null) {
      await box!.put("referralCode", profileModel.value.payload!.referralCode);
    }
  }
}
