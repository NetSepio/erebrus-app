import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erebrus_app/config/colors.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/responsive.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Responsive.scaleHeight(context, 15),
            horizontal: Responsive.scaleWidth(context, 20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  "assets/images/logo2.png",
                  height: Responsive.scaleHeight(context, Get.height * .3),
                ),
              ),
              SizedBox(height: Responsive.scaleHeight(context, 40)),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed("/authenticate", arguments: false);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(Responsive.scaleWidth(context, 13.0)),
                        child: Column(
                          children: [
                            const Text(
                              "NEW WALLET",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: Responsive.scaleHeight(context, 4)),
                            const Text(
                              "I Am Beginner",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.scaleHeight(context, 10)),
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
                                "Import An Existing Wallet",
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
