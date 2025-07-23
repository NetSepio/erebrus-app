import 'dart:developer';

// import 'package:aptos/aptos.dart';
import 'package:aptos/aptos_account.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/theme.dart';
import 'package:erebrus_app/controller/auth_controller.dart';
import 'package:erebrus_app/view/Onboarding/wallet_generator.dart';
import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:erebrus_app/view/inAppPurchase/ProFeaturesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PassettoLogin extends StatelessWidget {
  const PassettoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: black,
          appBar: AppBar(
            backgroundColor: black,
            leading: InkWell(
              onTap: () => Get.back(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back_ios, color: white),
              ),
            ),
          ),
          body: Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(20),
                  const Text(
                    "Enter Your Passetto",
                    style: TextStyle(color: white, fontSize: 18),
                  ),
                  // height(10),
                  // const Text(
                  //   "Login on website ",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(color: grey),
                  // ),
                  height(30),
                  TextField(
                    style: const TextStyle(color: white),
                    controller: controller.importAccountphrase,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: 9,
                    decoration: InputDecoration(
                      hintText: "Passetto",
                      isDense: true,
                      hintStyle: const TextStyle(color: grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff192E96),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        box!.put("token",
                            controller.importAccountphrase.text.trim());
                        // box!.put("web3WalletAddress", walletAddress);
                        // box!.put("userType", "web3Wallet");
                        Get.offAll(() => ProFeaturesScreen(fromLogin: true));
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Next"),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
