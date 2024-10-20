import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wire/api/api.dart';
import 'package:wire/components/widgets.dart';
import 'package:wire/config/assets.dart';
import 'package:wire/config/colors.dart';
import 'package:wire/config/common.dart';
import 'package:wire/config/strings.dart';
import 'package:wire/view/Onboarding/generate_phrase_screen.dart';
import 'package:wire/view/Onboarding/import_account_screen.dart';
import 'package:wire/view/home/home.dart';
import 'package:wire/view/profile/profile_model.dart';

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
            image: AssetImage(appBackground), fit: BoxFit.cover),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
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
                        erebrusLogoWordMark,
                        height: 50,
                      ),
                    ),
                    Image.asset(
                      solanaLogo,
                      height: 50,
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        welcome,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 50),
                      ),
                      const Text(
                        preferAc,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            // backgroundColor: Colors.white,
                            backgroundColor: blue,
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
                                  image: AssetImage(googleLogo),
                                  height: 18.0,
                                  width: 24,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 24, right: 8),
                                  child: Text(
                                    loginWithGoogle,
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
                      const SizedBox(height: 20),
                      MyButton(
                        customColor: blue,
                        text: importAccount,
                        onTap: () {
                          Get.to(() => const ImportAccountScreen());
                        },
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        customColor: blue,
                        text: generateSeedPhrase,
                        onTap: () {
                          Get.to(() => const GenerateSeedPhrase());
                        },
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
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
                          termsOfUse,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          launchUrl(Uri.parse("https://erebrus.io/privacy"));
                        },
                        // onTap: () => Get.to(() => const PrivacyPolicy()),
                        child: const Text(
                          privacyPolicy,
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
          title: const Text(enterAuthToken),
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
                  child: const Text(loginTxt)),
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
