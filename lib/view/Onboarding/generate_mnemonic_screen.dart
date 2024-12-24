import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/theme.dart';
import 'package:erebrus_app/controller/auth_controller.dart';
import 'package:erebrus_app/view/Onboarding/verify_mnemonic_screen.dart';

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
              const Text(
                "Back Up Mnemonics",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
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
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10),
                        children: [
                          TextSpan(
                            text: authController.phrase[index],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
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
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    if (widget.view) {
                      Navigator.pop(context);
                    } else {
                      authController.privateKeyFromMnemonic().then((_) {
                        Get.to(
                          () => VerifyPhraseScreen(
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
      ),
    );
  }
}
