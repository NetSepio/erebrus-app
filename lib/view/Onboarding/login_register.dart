import 'dart:developer';
import 'dart:io';
import 'package:aptos/aptos_account.dart';
import 'package:erebrus_app/api/api.dart';
import 'package:erebrus_app/components/reownInit.dart';
import 'package:erebrus_app/components/widgets.dart';
import 'package:erebrus_app/config/assets.dart';
import 'package:erebrus_app/config/colors.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/strings.dart';
import 'package:erebrus_app/main.dart';
import 'package:erebrus_app/view/Onboarding/generate_mnemonic_screen.dart';
import 'package:erebrus_app/view/Onboarding/import_account_screen.dart';
import 'package:erebrus_app/view/Onboarding/solanaConnectController.dart';
import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  ReownAppKitModal? appKitModal;
  final controller = Get.put(ClientController());
  HomeController homeController = Get.find();

  @override
  void initState() {
    if (appEnvironmentFor != "saga") config();
    super.initState();
  }

  config() async {
    appKitModal = await reownInit(context);
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
                        const SizedBox(height: 60),
                        const SizedBox(height: 30),
                        if (Platform.isIOS)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: SignInWithAppleButton(
                              onPressed: () async {
                                try {
                                  final credential = await SignInWithApple
                                      .getAppleIDCredential(
                                    scopes: [AppleIDAuthorizationScopes.email],
                                  );

                                  log("APPle credential ${credential}");
                                  log("APPle credential userIdentifier ${credential.userIdentifier}");
                                  // if (credential.email != null) {
                                  await ApiController().googleAppleLogin(
                                      email: credential.email ?? "",
                                      authType: "apple",
                                      appleId: credential.userIdentifier!);
                                } catch (e) {
                                  Fluttertoast.showToast(
                                      msg: "Something want wrong");
                                  log("message----EEE---$e");
                                }
                              },
                            ),
                          ),
                        if (appEnvironmentFor != "saga")
                          if (Platform.isAndroid)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
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
                                        email: result.email,
                                        authType: "google");
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
                        // AppKitModalConnectButton(appKit: appKitModal!),
                        // AppKitModalAccountButton(appKitModal: appKitModal!),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       List a = ReownAppKitModalNetworks
                        //           .getAllSupportedNetworks(
                        //         namespace: 'eip155',
                        //       ).map((chain) => '${chain.chainId}').toList();
                        //       print("Default Network Events: $a");
                        //     },
                        //     child: Text("Default Network Events")),
                        // AppKitModalNetworkSelectButton(appKit: appKitModal!),
                        if (appEnvironmentFor != "saga")
                          if (appKitModal != null) const SizedBox(height: 20),
                        if (appEnvironmentFor != "saga")
                          if (appKitModal != null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.all(13),
                                      decoration: BoxDecoration(
                                          color: blue, shape: BoxShape.circle),
                                      child: Image.asset(
                                        "assets/evm.png",
                                        height: 30,
                                      ),
                                    ),
                                    onTap: () async {
                                      await appKitModal!.openNetworksView();
                                    },
                                  ),
                                  solanaLoginBtn(),
                                ],
                              ),
                            )
                          else
                            Center(child: CircularProgressIndicator()),
                        if (appEnvironmentFor == "saga")
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: solanaLoginBtn(),
                          ),
                        SizedBox(height: 20),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 20, right: 20),
                        //   child: MyButton(
                        //     customColor: blue,
                        //     text: importAccount,
                        //     onTap: () {
                        //       Get.to(() => const ImportAccountScreen());
                        //     },
                        //   ),
                        // ),
                        // const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: MyButton(
                            customColor: blue,
                            text: appEnvironmentFor == "saga"
                                ? "Create Wallet"
                                : generateSeedPhrase,
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

  FutureBuilder<bool> solanaLoginBtn() {
    return FutureBuilder(
        future: controller.isWalletAvailable(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          }
          if (snapshot.hasError) {
            return Expanded(
              child: MyButton(
                customColor: blue,
                text: 'Solana App Not Found',
                onTap: () async {
                  Fluttertoast.showToast(msg: "Solana wallet not available");
                },
              ),
            );
          }
          return InkWell(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: blue,
                borderRadius: appEnvironmentFor == "saga"
                    ? BorderRadius.circular(100)
                    : null,
                shape: appEnvironmentFor != "saga"
                    ? BoxShape.circle
                    : BoxShape.rectangle,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/solo.png",
                    height: 30,
                  ),
                  if (appEnvironmentFor == "saga")
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        "Solana Wallet",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                ],
              ),
            ),
            onTap: () async {
              try {
                await controller.authorize().then((value) async {
                  if (controller.address != null) {
                    box!.put("solanaAddress", controller.address!);
                    var res = await homeController.getPASETO(
                        chain: "sol", walletAddress: controller.address!);
                  } else {
                    Fluttertoast.showToast(msg: "Wallet not connected");
                  }
                });
              } catch (e) {
                Fluttertoast.showToast(msg: "Solan apps not found");
              }
            },
          );
        });
  }

  // Future<dynamic> textLogin(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       TextEditingController textEditingController = TextEditingController();
  //       return AlertDialog(
  //         title: const Text(enterAuthToken),
  //         content: TextField(
  //           controller: textEditingController,
  //           decoration: const InputDecoration(
  //             hintText: "Paste your PASETO here",
  //             border: OutlineInputBorder(),
  //           ),
  //         ),
  //         actions: [
  //           Center(
  //             child: ElevatedButton(
  //                 onPressed: () async {
  //                   try {
  //                     box!.put("token", textEditingController.text);
  //                     ProfileModel ress = await ApiController().getProfile();
  //                     if (ress.status != null && ress.status == 200) {
  //                       Get.offAll(() => const HomeScreen());
  //                     }
  //                   } catch (e) {
  //                     Get.back();
  //                     Fluttertoast.showToast(msg: "Invalid Auth Token");
  //                   }
  //                 },
  //                 child: const Text(loginTxt)),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  // login({required token}) async {
  //   try {
  //     box!.put("token", token);
  //     log("TOkenn---  ${box!.get("token")}");
  //     ProfileModel ress = await ApiController().getProfile();
  //     if (ress.status != null && ress.status == 200) {
  //       Get.offAll(() => const HomeScreen());
  //     }
  //   } catch (e) {
  //     Get.back();
  //     Fluttertoast.showToast(msg: "Invalid Auth Token");
  //   }
  // }
}
