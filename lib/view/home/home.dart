import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wire/config/assets.dart';
import 'package:wire/config/secure_storage.dart';
import 'package:wire/view/bottombar/bottombar.dart';
import 'package:wire/view/home/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();
  final storage = SecureStorage();

  @override
  void initState() {
    homeController.getProfileData();
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
            return const BottomBar();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text("EREBRUS"),
                centerTitle: true,
                actions: const [],
              ),
              body: const NoWalletFound(),
            );
          }
        },
      ),
    );
  }
}

class NoWalletFound extends StatelessWidget {
  const NoWalletFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: Get.width),
          Image.asset(noWalletFound, height: 100),
          const Text(
            "No Wallet Found. Please Link A Solana Wallet to Your Profile",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          ElevatedButton(
              onPressed: () async {
                await launchUrl(Uri.parse("https://app.netsepio.com/"));
              },
              child: const Text("Link Wallet"))
        ],
      ),
    );
  }
}
