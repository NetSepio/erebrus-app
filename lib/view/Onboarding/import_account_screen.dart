import 'dart:developer';

// import 'package:aptos/aptos.dart';
import 'package:aptos/aptos_account.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/secure_storage.dart';
import 'package:erebrus_app/config/theme.dart';
import 'package:erebrus_app/controller/auth_controller.dart';
import 'package:erebrus_app/view/Onboarding/wallet_generator.dart';
import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ImportAccountScreen extends StatelessWidget {
  const ImportAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff192E96),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        controller.privateKeyFromMnemonic(
                            newMnemonic:
                                controller.importAccountphrase.text.trim());
                        showDialog(
                            context: context,
                            builder: (a) => Dialog(
                                  child: NetworkSelectionScreen(
                                    mnemonic: controller
                                        .importAccountphrase.text
                                        .trim(),
                                  ),
                                ));
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

class NetworkSelectionScreen extends StatefulWidget {
  final String mnemonic;
  const NetworkSelectionScreen({super.key, required this.mnemonic});
  @override
  _NetworkSelectionScreenState createState() => _NetworkSelectionScreenState();
}

class _NetworkSelectionScreenState extends State<NetworkSelectionScreen> {
  final List<String> networks = [
    "Solana",
    "Peaq",
    "Eclipse",
    "Aptos",
    "Sui",
    "Monad"
  ];
  String? selectedNetwork;

  final storage = SecureStorage();
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Scaffold(
        backgroundColor: Color(0xff2D2D2D),
        appBar: AppBar(
          title: Text("Choose Your Network"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: ListView.builder(
          itemCount: networks.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(networks[index]),
              leading: Radio<String>(
                value: networks[index],
                groupValue: selectedNetwork,
                onChanged: (value) {
                  setState(() {
                    selectedNetwork = value;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  selectedNetwork = networks[index];
                });
              },
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff192E96),
              foregroundColor: Colors.white,
            ),
            onPressed: selectedNetwork == null
                ? null
                : () async {
                    print("Selected Network: $selectedNetwork");
                    box!.put("selected_network", selectedNetwork);
                    final storage = SecureStorage();
                    String mnemonics =
                        await storage.getStoredValue("mnemonic") ?? "mp";
                    log(mnemonics);
                    if (selectedNetwork == "Solana" ||
                        selectedNetwork == "Eclipse") {
                      EasyLoading.show();

                      final sender =
                          await WalletGenerator.getAddressFromMnemonic(
                              mnemonics);

                      log("Wallet Address --- $sender");
                      var res = await homeController.getPASETO(
                          chain: "sol", walletAddress: sender);
                    } else if (selectedNetwork == "Peaq" ||
                        selectedNetwork == "Aptos" ||
                        selectedNetwork == "Monad") {
                      EasyLoading.show();
                      var pvtKey = await storage.getStoredValue('pvtKey');
                      final sender = AptosAccount.generateAccount(mnemonics);

                      log("Wallet Address $pvtKey");
                      log("Wallet Address hex ${sender.accountAddress.hex()}");
                      var res = await homeController.getPASETO(
                          chain: "", walletAddress: sender.address);
                    }
                  },
            child: Text("Select"),
          ),
        ),
      ),
    );
  }
}
