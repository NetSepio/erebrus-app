import 'package:dio/dio.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/secure_storage.dart';
import 'package:erebrus_app/controller/profileContrller.dart';
import 'package:erebrus_app/view/Onboarding/wallet_generator.dart';
import 'package:erebrus_app/view/profile/walletSelection.dart';
import 'package:erebrus_app/view/subscription/subscriptionScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  final String title;
  final bool showBackArrow;

  const Profile({super.key, required this.title, required this.showBackArrow});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  RxString solanaAddress = "".obs;
  final storage = SecureStorage();
  ProfileController profileController = Get.find();


  apiCall() async {
    var mnemonics = await profileController.mnemonics.value;
    await getSolanaAddress(mnemonics);
    await suiWal(mnemonics);
    await getEclipseAddress(mnemonics);
    await getSoonAddress(mnemonics);
    setState(() {});
  }


  @override
  void initState() {
    apiCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.title),
          centerTitle: true,
          automaticallyImplyLeading: widget.showBackArrow ? true : false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: [
                Obx(() => (profileController.profileModel.value.payload !=
                            null &&
                        profileController.profileModel.value.payload!.email !=
                            null)
                    ? TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: profileController
                              .profileModel.value.payload!.email
                              .toString(),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                        ),
                      )
                    : SizedBox()),
                if (box!.get("solanaAddress") == null)
                  Expanded(
                      child: SubscriptionScreen(
                    showAppbar: false,
                  )),
                if (box!.get("solanaAddress") != null)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Your Preferred Wallet",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      WalletDropdown(
                        fromProfileScreen: widget.title == "Profile",
                      ),
                    ],
                  ),
                SizedBox(height: 10),
               
                ],
            ),
          ),
        ),
      ),
    );
  }
}
