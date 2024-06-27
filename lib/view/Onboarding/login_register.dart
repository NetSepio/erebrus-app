import 'dart:developer';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wire/api/api.dart';
import 'package:wire/components/widgets.dart';
import 'package:wire/config/common.dart';
import 'package:wire/view/home/home.dart';
import 'package:wire/view/profile/profile_model.dart';
import 'package:wire/view/setting/PrivacyPolicy.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 19, 18, 18),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 140),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 50, bottom: 50, left: 20, right: 20),
                    child: Image.asset(
                      "assets/Erebrus_logo_wordmark.png",
                      height: 100,
                      // color: const Color.fromARGB(255, 10, 185, 121),
                    ),
                  ),

                  // sign in button
                  // MyButton(
                  //   customColor: Colors.white.withOpacity(0.7),
                  //   text: "Sign in",
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const SignInPage(),
                  //       ),
                  //     );
                  //   },
                  // ),

                  const SizedBox(height: 20),

                  // // create an account button

                  // MyButton(
                  //   customColor: const Color.fromARGB(255, 10, 185, 121),
                  //   text: "Import account",
                  //   onTap: () {
                  //     Get.to(() => const ImportAccountScreen());
                  //   },
                  // ),
                  // const SizedBox(height: 20),

                  const SizedBox(height: 20),
                  MyButton(
                    customColor: const Color.fromARGB(255, 10, 185, 121),
                    text: "Login Using PASETO",
                    onTap: () async {
                      var parset0 = "";
                      await Get.to(
                        () => AiBarcodeScanner(
                          title: "Enter PASETO",
                          hideDragHandler: true,
                          onDetect: (BarcodeCapture barcodeCapture) {
                            log("message---   ${barcodeCapture.barcodes.first.displayValue}");
                            if (barcodeCapture.barcodes.first.displayValue !=
                                null) {
                              parset0 = barcodeCapture
                                  .barcodes.first.displayValue
                                  .toString();
                              Get.back();
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        textLogin(context);
                                      },
                                      child: const Text("Enter PASETO")),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      await login(token: parset0);
                    },
                  ),
                  const SizedBox(height: 20),

                  // const MyButton(
                  //   customColor: Colors.grey,
                  //   text: "Google SignIn",
                  //   onTap: null,
                  // ),
                  InkWell(
                    onTap: () async {
                      final GoogleSignIn googleSignIn = GoogleSignIn();
                      final result = await googleSignIn.signIn();
                      final ggAuth = await result!.authentication;
                      print("idToken - ${ggAuth.idToken}");
                      log("idToken - ${ggAuth.idToken}");

                      // await ApiController()
                      //     .googleAuth(idToken: ggAuth.idToken.toString());
                      await ApiController()
                          .googleEmailLogin(email: result.email);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Image.asset("assets/images/google.png", width: 20),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // const MyButton(
                  //     customColor:
                  //         Colors.grey, // Color.fromARGB(255, 10, 185, 121),
                  //     text: "Generate Seed Phrase",
                  //     onTap: null
                  //     //  () {
                  //     //   Get.to(() => const GenerateSeedPhrase());
                  //     // },
                  //     ),
                ],
              ),

              const Spacer(),
              // Footer
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        launchUrl(Uri.parse("https://erebrus.io/terms"));
                      },
                      child: const Text(
                        "Terms of Use",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () => Get.to(() => const PrivacyPolicy()),
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> textLogin(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        TextEditingController textEditingController = TextEditingController();
        return AlertDialog(
          title: const Text("Enter Auth Token"),
          content: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              hintText: "Paste your PASETO here",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      box!.put("token", textEditingController.text);
                      ProfileModel ress = await ApiController().getProfile();
                      if (ress.status != null && ress.status == 200) {
                        Get.offAll(() => const HomeScreen());
                      }
                    } catch (e) {
                      Get.back();
                      Fluttertoast.showToast(msg: "Invalid Auth Token");
                    }
                  },
                  child: const Text("Login")),
            )
          ],
        );
      },
    );
  }

  login({required token}) async {
    try {
      box!.put("token", token);
      log("TOkenn---  ${box!.get("token")}");
      ProfileModel ress = await ApiController().getProfile();
      if (ress.status != null && ress.status == 200) {
        Get.offAll(() => const HomeScreen());
      }
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(msg: "Invalid Auth Token");
    }
  }
}
