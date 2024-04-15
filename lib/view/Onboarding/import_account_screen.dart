import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wire/config/common.dart';
import 'package:wire/config/theme.dart';
import 'package:wire/controller/auth_controller.dart';
import 'package:wire/view/home/home.dart';

class ImportAccountScreen extends StatelessWidget {
  const ImportAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: black,
          body: Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SafeArea(
                    child: Icon(Icons.arrow_back_ios, color: white),
                  ),
                  height(50),
                  const Text(
                    "Enter your secret phrase",
                    style: TextStyle(color: white, fontSize: 18),
                  ),
                  height(10),
                  const Text(
                    "Enter each word in the order",
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
                      onPressed: () {
                        controller.privateKeyFromMnemonic(
                            newMnemonic:
                                controller.importAccountphrase.text.trim());
                        Get.offAll(() => const HomeScreen());
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
