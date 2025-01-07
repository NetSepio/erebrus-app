import 'dart:developer';

import 'package:aptos/aptos.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/secure_storage.dart';
import 'package:erebrus_app/config/theme.dart';
import 'package:erebrus_app/controller/auth_controller.dart';
import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportAccountScreen extends StatelessWidget {
  const ImportAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = SecureStorage();
    HomeController homeController = Get.find();
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
                    "Enter Your Secret Phrase",
                    style: TextStyle(color: white, fontSize: 18),
                  ),
                  height(10),
                  const Text(
                    "Enter Each Word In The Order",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: grey),
                  ),
                  height(30),
                  TextField(
                    style: const TextStyle(color: white),
                    controller: controller.importAccountphrase,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: 9,
                    decoration: InputDecoration(
                      hintText: "Phrase",
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
                      onPressed: () async {
                        await controller.privateKeyFromMnemonic(
                            newMnemonic:
                                controller.importAccountphrase.text.trim());
                        String mnemonics =
                            await storage.getStoredValue("mnemonic") ?? "";
                        String accountAddress =
                            await storage.getStoredValue("accountAddress") ??
                                "";
                        final sender = AptosAccount.generateAccount(mnemonics);
                        // log("Wallet Address -=- ${sender.address}");
                        // log("Wallet Address -=- ${accountAddress}");
                        var res = await homeController.getPASETO(
                            walletAddress: sender.address);
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
