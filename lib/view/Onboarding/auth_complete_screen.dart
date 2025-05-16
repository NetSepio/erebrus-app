import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/secure_storage.dart';
import 'package:erebrus_app/config/theme.dart';
import 'package:erebrus_app/controller/auth_controller.dart';
import 'package:erebrus_app/view/Onboarding/import_account_screen.dart';
import 'package:erebrus_app/view/Onboarding/wallet_generator.dart';
import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AuthCompleteScreen extends StatefulWidget {
  const AuthCompleteScreen({super.key});

  @override
  State<AuthCompleteScreen> createState() => _AuthCompleteScreenState();
}

class _AuthCompleteScreenState extends State<AuthCompleteScreen> {
  AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final storage = SecureStorage();
    HomeController homeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
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
                    color: Colors.grey,
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
                    color: Colors.grey,
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
                    color: Colors.grey,
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
              activeColor: Colors.blueAccent.shade700,
              checkColor: Colors.white,
              onChanged: (v) {},
              title: const Text(
                "I Understand That I Am Responsible For The Security Of My Mnemonic.",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        String mnemonics =
                            await storage.getStoredValue("mnemonic") ?? "";
                        showDialog(
                            context: context,
                            builder: (a) => Dialog(
                                  child: NetworkSelectionScreen(
                                    mnemonic: mnemonics,
                                  ),
                                ));
                        // var pvtKey = await storage.getStoredValue('pvtKey');
                        // final sender = AptosAccount.generateAccount(mnemonics);
                        // log("Wallet Address $pvtKey");
                        // log("Wallet Address hex ${sender.accountAddress.hex()}");
                        // var res = await homeController.getPASETO(
                        //     walletAddress: sender.address);
                        // Get.offAll(() => const HomeScreen());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade700,
                          foregroundColor: Colors.white),
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
