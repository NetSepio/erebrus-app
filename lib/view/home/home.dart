import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wire/config/common.dart';
import 'package:wire/view/home/home_controller.dart';
import 'package:wire/view/vpn/vpn_home.dart';
import 'package:wire/view/vpn/vpn_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();
  @override
  void initState() {
    homeController.getProfileData();
    log("token -- " + box!.get("token"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        init: homeController,
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.profileModel != null &&
              controller.profileModel!.value.payload != null) {
            return const VpnHomeScreen();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Erebrus"),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: Get.width),
                    Image.asset(
                      "assets/images/sad.png",
                      height: 100,
                    ),
                    const Text(
                      "No Wallet found. Please link an Aptos Wallet to your profile.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await launchUrl(
                              Uri.parse("https://app.netsepio.com/"));
                        },
                        child: const Text("link Wallet"))
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
