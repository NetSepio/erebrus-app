import 'dart:developer';
import 'dart:io';
import 'package:aptos/aptos_account.dart';
import 'package:erebrus_app/api/api.dart';
import 'package:erebrus_app/components/widgets.dart';
import 'package:erebrus_app/config/assets.dart';
import 'package:erebrus_app/config/colors.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/strings.dart';
import 'package:erebrus_app/main.dart';
import 'package:erebrus_app/view/Onboarding/PassettoLogin.dart';
import 'package:erebrus_app/view/Onboarding/generate_mnemonic_screen.dart';
import 'package:erebrus_app/view/Onboarding/import_account_screen.dart';
import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  HomeController homeController = Get.find();

  @override
  void initState() {
    if (appEnvironmentFor != "saga") config();
    super.initState();
  }

  config() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // if (appKitModal != null) {
    // print("connected--> ${appKitModal!.isConnected!}");
    // final chainId = appKitModal!.selectedChain?.chainId ?? '';
    // final namespace = NamespaceUtils.getNamespaceFromChain(chainId);
    // final address = appKitModal!.session!.getAddress(namespace);
    // }
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
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () async {
                        final sender = AptosAccount.generateAccount(
                            "crop soap van result kind laundry obey grass push opinion jelly climb");

                        var res = await homeController.getPASETO(
                            chain: "", walletAddress: sender.address);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          "Skip",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      )),
                ),
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

                    // Image.asset(
                    //   solanaLogo,
                    //   height: 50,
                    // ),
                    SizedBox(width: 20),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
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
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        const SizedBox(height: 30),
                        if (Platform.isAndroid)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                // backgroundColor: Colors.white,
                                backgroundColor: blue,
                              ),
                              onPressed: () async {
                                final GoogleSignIn googleSignIn =
                                    GoogleSignIn();
                                try {
                                  EasyLoading.show();
                                  final result = await googleSignIn.signIn();
                                  final ggAuth = await result!.authentication;
                                  print("idToken - ${ggAuth.idToken}");
                                  log("idToken - ${ggAuth.idToken}");

                                  // await ApiController()
                                  //     .googleAuth(idToken: ggAuth.idToken.toString());
                                  await ApiController().googleAppleLogin(
                                      email: result.email, authType: "google");
                                } catch (e) {
                                  EasyLoading.dismiss();
                                  log("Errorr--- ${e}");
                                }
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
                                      padding:
                                          EdgeInsets.only(left: 24, right: 8),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: MyButton(
                            customColor: blue,
                            text: "Passetto Login",
                            onTap: () {
                              launchUrl(Uri.parse("https://erebrus.io"));
                              Get.to(() => PassettoLogin());
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: MyButton(
                            customColor: blue,
                            text: "Import Account",
                            onTap: () {
                              Get.to(() => ImportAccountScreen());
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: MyButton(
                            customColor: blue,
                            text: generateSeedPhrase,
                            onTap: () {
                              Get.to(() => const GenerateSeedPhrase());
                            },
                          ),
                        ),
                        const SizedBox(height: 160),
                      ],
                    ),
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
}
