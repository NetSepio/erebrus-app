import 'dart:developer';

import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/secure_storage.dart';
import 'package:erebrus_app/config/theme.dart';
import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthCompleteScreen extends StatelessWidget {
  const AuthCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = SecureStorage();
    HomeController homeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "",
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Do Remember!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              height(15),
              const Divider(),
              height(15),
              const ListTile(
                leading: Icon(Icons.vpn_key),
                title: Text(
                  "The Mnemonic Is the Key to Your Wallet",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Obtaining Your Mnemonic Means Obtaining Your Assets",
                  style: TextStyle(
                    color: blueGray,
                  ),
                ),
              ),
              height(20),
              const ListTile(
                leading: Icon(Icons.edit),
                title: Text(
                  "Transcribe the Mnemonics",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Do Not Make Copies Or Take Screenshots",
                  style: TextStyle(
                    color: blueGray,
                  ),
                ),
              ),
              height(20),
              const ListTile(
                leading: Icon(Icons.health_and_safety),
                title: Text(
                  "Store In A Safe Place.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Once Lost, The Assets Cannot Be Recovered.",
                  style: TextStyle(
                    color: blueGray,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: true,
              dense: true,
              activeColor: Colors.blue.shade900,
              onChanged: (v) {},
              title: const Text(
                "I Understand That I Am Responsible For The Security Of My Mnemonic.",
                style: TextStyle(fontWeight: FontWeight.w100),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        String mnemonics =
                            await storage.getStoredValue("mnemonic") ?? "";
                        String accountAddress =
                            await storage.getStoredValue("accountAddress") ??
                                "";
                        log("Wallet Address-=  ${accountAddress}");
                        var res = await homeController.getPASETO(
                            walletAddress: accountAddress);
                        // Get.offAll(() => const HomeScreen());
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Done"),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
