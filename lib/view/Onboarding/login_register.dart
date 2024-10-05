import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wire/api/api.dart';
import 'package:wire/components/widgets.dart';
import 'package:wire/config/common.dart';
import 'package:wire/view/Onboarding/generate_phrase_screen.dart';
import 'package:wire/view/Onboarding/import_account_screen.dart';
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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/bg.png"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        // backgroundColor: const Color.fromARGB(255, 19, 18, 18),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 50, bottom: 50, left: 20, right: 20),
                      child: Image.asset(
                        "assets/Erebrus_logo_wordmark.png",
                        height: 50,
                        // color: const Color.fromARGB(255, 10, 185, 121),
                      ),
                    ),
                    // Image.asset(
                    //   "assets/solo.png",
                    //   height: 50,
                    // ),
                    Image.asset(
                      "assets/sc.png",
                      height: 60,
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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

                      const Text(
                        "Welcome",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 50),
                      ),
                      const Text(
                        "Please Login with your preffered account",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            // backgroundColor: Colors.white,
                            backgroundColor: const Color(0xff3985FF),
                          ),
                          onPressed: () async {
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
                          child: const SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("assets/images/google.png"),
                                  height: 18.0,
                                  width: 24,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 24, right: 8),
                                  child: Text(
                                    'Login with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      // MyButton(
                      //   customColor: const Color(0xff3985FF),
                      //   text: "Login Using PASETO",
                      //   onTap: () async {
                      //     var parset0 = "";
                      //     await Get.to(
                      //       () => AiBarcodeScanner(
                      //         title: "Enter PASETO",
                      //         hideDragHandler: true,
                      //         onDetect: (BarcodeCapture barcodeCapture) {
                      //           log("message---   ${barcodeCapture.barcodes.first.displayValue}");
                      //           if (barcodeCapture
                      //                   .barcodes.first.displayValue !=
                      //               null) {
                      //             parset0 = barcodeCapture
                      //                 .barcodes.first.displayValue
                      //                 .toString();
                      //             Get.back();
                      //           }
                      //         },
                      //         child: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Center(
                      //               child: ElevatedButton(
                      //                   onPressed: () {
                      //                     textLogin(context);
                      //                   },
                      //                   child: const Text(
                      //                     "Enter PASETO",
                      //                   )),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //     await login(token: parset0);
                      //   },
                      // ),
                      const SizedBox(height: 20),

                      MyButton(
                        // logoUrl: "assets/solo.png",
                        customColor: const Color(0xff3985FF),
                        text: "Import account",
                        onTap: () {
                          Get.to(() => const ImportAccountScreen());
                        },
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        customColor: const Color(0xff3985FF),
                        text: "Generate Seed Phrase",
                        onTap: () {
                          Get.to(() => const GenerateSeedPhrase());
                        },
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),

                // const Spacer(),
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
