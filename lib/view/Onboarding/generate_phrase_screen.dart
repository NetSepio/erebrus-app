import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wire/config/common.dart';
import 'package:wire/config/theme.dart';
import 'package:wire/controller/auth_controller.dart';
import 'package:wire/view/Onboarding/verify_phrase_screen.dart';

class GenerateSeedPhrase extends StatefulWidget {
  final bool view;
  const GenerateSeedPhrase({super.key, this.view = false});

  @override
  State<GenerateSeedPhrase> createState() => _GenerateSeedPhraseState();
}

class _GenerateSeedPhraseState extends State<GenerateSeedPhrase> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: blackrussion,
            appBar: AppBar(
              backgroundColor: blackrussion,
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
                      child: FutureBuilder<String?>(
                          future: controller.getMnemonic,
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              controller.phrase =
                                  snapshot.data!.toString().split(" ");
                              log(controller.phrase.toString());
                              return GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 16 / 10),
                                itemCount: controller.phrase.length,
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
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 10),
                                          children: [
                                            TextSpan(
                                              text: controller.phrase[index],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )
                                          ])),
                                ),
                              );
                            } else {
                              controller.phrase = controller.generateMnemonic
                                  .toString()
                                  .split(" ");
                              log(controller.phrase.toString());
                              return GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 16 / 9),
                                itemCount: controller.phrase.length,
                                itemBuilder: (_, index) => FittedBox(
                                  fit: BoxFit.fill,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10, bottom: 8, right: 6),
                                    child: RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                            text: "${index + 1}. ",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                            children: [
                                              TextSpan(
                                                text: controller.phrase[index],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              )
                                            ])),
                                  ),
                                ),
                              );
                            }
                          }),
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
                            controller
                                .privateKeyFromMnemonic()
                                .then((_) => Get.to(() => VerifyPhraseScreen(
                                      words: controller.mnemonic.split(" "),
                                    )));
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
        });
  }
}
