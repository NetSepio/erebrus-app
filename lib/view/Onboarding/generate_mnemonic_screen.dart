import 'dart:developer';

import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/theme.dart';
import 'package:erebrus_app/controller/auth_controller.dart';
import 'package:erebrus_app/view/Onboarding/verify_mnemonic_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class GenerateSeedPhrase extends StatefulWidget {
  final bool view;
  const GenerateSeedPhrase({super.key, this.view = false});

  @override
  State<GenerateSeedPhrase> createState() => _GenerateSeedPhraseState();
}

class _GenerateSeedPhraseState extends State<GenerateSeedPhrase> {
  AuthController authController = Get.put(AuthController());
  @override
  void initState() {
    generateKey();
    super.initState();
  }

  generateKey() async {
    var kk = authController.generateMnemonic;
    // var kk = await authController.getMnemonic;
    authController.phrase = kk.toString().split(" ");

    log("---- ${authController.phrase}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackRussion,
      appBar: AppBar(
        backgroundColor: blackRussion,
        title: const Text(
          "My Wallet",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Back Up Mnemonics",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () async {
                      log("${authController.phrase.join(" ")}");
                      await Clipboard.setData(
                          ClipboardData(text: authController.phrase.join(" ")));
                      Fluttertoast.showToast(msg: "Mnemonics Copied");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.copy,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              height(30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey.shade50,
                    width: 0.1,
                  ),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 16 / 10),
                  itemCount: authController.phrase.length,
                  itemBuilder: (_, index) => Container(
                    width: Get.width / 4,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    padding: const EdgeInsets.only(
                        left: 10, top: 10, bottom: 8, right: 6),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        text: "${index + 1}. ",
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 12),
                        children: [
                          TextSpan(
                            text: authController.phrase[index],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              height(Get.height * .1),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.grey.shade300),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Your seed Phrase is the key to used to back up your wallet. keep it secret and secure at all time.",
                      style: TextStyle(color: Colors.grey.shade300),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade700,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        if (widget.view) {
                          Navigator.pop(context);
                        } else {
                          authController.privateKeyFromMnemonic().then((_) {
                            Get.to(
                              () => VerifyMnemonicScreen(
                                words: authController.phrase,

                                // controller.mnemonic.split(" "),
                              ),
                            );
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(widget.view ? "Back" : "Next"),
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
