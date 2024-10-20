import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wire/config/assets.dart';
import 'package:wire/config/colors.dart';
import 'package:wire/config/strings.dart';
import 'package:wire/view/Onboarding/login_register.dart';
import 'package:wire/view/setting/PrivacyPolicy.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: blue),
        color: _currentPage == index ? blue : Colors.black,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: 10,
    );
  }

  Future<void> _checkLocationPermission() async {
    if (await Permission.location.isGranted) {
      Get.to(() => const LoginOrRegisterPage());
      return;
    }

    // Show prominent disclosure
    _showProminentDisclosure();
  }

  void _showProminentDisclosure() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            locationPermissionRequired,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(locationPermissionSubText,
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Get.to(() => const PrivacyPolicy());
                },
                child: const Text(
                  privacyPolicy,
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child:  Text(deny),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: const Text(allow),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      // Request location permission
                      await _requestLocationPermission();
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      Get.to(() => const LoginOrRegisterPage());
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: const Color(0xff040819),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Image.asset(
                          contents[i].image,
                          height: SizeConfig.blockV! * 42,
                        ),
                        SizedBox(
                          height: (height >= 840) ? 60 : 30,
                        ),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w600,
                            fontSize: (width <= 550) ? 30 : 35,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          contents[i].desc,
                          style: TextStyle(
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w300,
                            fontSize: (width <= 550) ? 17 : 25,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (int index) => _buildDots(
                        index: index,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade900,
                          blurRadius: 20,
                          offset: const Offset(0, 3),
                          spreadRadius: 0.0,
                        ),
                      ]),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage + 1 == contents.length) {
                            _checkLocationPermission();
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            );
                          }
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: (width <= 550)
                              ? const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15)
                              : EdgeInsets.symmetric(
                                  horizontal: width * 0.2, vertical: 20),
                          textStyle:
                              TextStyle(fontSize: (width <= 550) ? 13 : 16),
                        ),
                        child: Text(
                          _currentPage + 1 == contents.length
                              ? "START"
                              : "NEXT",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenW;
  static double? screenH;
  static double? blockH;
  static double? blockV;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenW = _mediaQueryData!.size.width;
    screenH = _mediaQueryData!.size.height;
    blockH = screenW! / 100;
    blockV = screenH! / 100;
  }
}

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Decentralize Your Internet",
    image: onboarding1,
    desc:
        "Unlock the Power of a Robust Network for Unmatched Resilience and Security",
  ),
  OnboardingContents(
    title: "High-Speed Unlimited Bandwidth",
    image: onboarding2,
    desc:
        "fast internet without limitations, tailored for seamless browsing and streaming",
  ),
  OnboardingContents(
    title: "Permission to Secure Your Connection",
    image: onboarding3,
    desc:
        "Allow access to your location and wifi to optimize your network security",
  ),
];
