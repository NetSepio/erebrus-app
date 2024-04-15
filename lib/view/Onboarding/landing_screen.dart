import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wire/config/colors.dart';
import 'package:wire/config/common.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset("assets/images/logo2.png",
                    height: Get.height * .3),
              ),
              height(40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed("/authenticate", arguments: false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          children: [
                            const Text(
                              "NEW WALLET",
                              style: TextStyle(color: Colors.white),
                            ),
                            height(4),
                            const Text(
                              "I am beginner",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              height(10),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                        ),
                        onPressed: () {
                          Get.toNamed("/authenticate", arguments: true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                "IMPORT WALLET",
                                style: TextStyle(color: Colors.white),
                              ),
                              height(4),
                              const Text(
                                "Import an existing wallet",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
