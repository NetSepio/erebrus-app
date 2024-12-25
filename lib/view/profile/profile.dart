import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/secure_storage.dart';
import 'package:erebrus_app/controller/profileContrller.dart';
import 'package:erebrus_app/view/Onboarding/eclipseAddress.dart';
import 'package:erebrus_app/view/Onboarding/solanaAddress.dart';
import 'package:erebrus_app/view/Onboarding/soonAddress.dart';
import 'package:erebrus_app/view/profile/walletSelection.dart';
import 'package:erebrus_app/view/subscription/subscriptionScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  final String title;
  final bool showBackArrow;

  const Profile({super.key, required this.title, required this.showBackArrow});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  RxString solanaAddress = "".obs;
  final storage = SecureStorage();
  ProfileController profileController = Get.find();

  apiCall() async {
    var mnemonics = await profileController.mnemonics.value;
    await getSolanaAddress(mnemonics);
    await suiWal(mnemonics);
    await getEclipseAddress(mnemonics);
    await getSoonAddress(mnemonics);
    await evmAptos(mnemonics);
    setState(() {});
  }

  @override
  void initState() {
    apiCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.title),
          centerTitle: true,
          automaticallyImplyLeading: widget.showBackArrow ? true : false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: [
                // if (ed25519 != null)
                //   Row(
                //     children: [
                //       Image.asset(
                //         "assets/sui.png",
                //         width: 35,
                //       ),
                //       SizedBox(width: 10),
                //       Expanded(
                //         child: TextField(
                //           readOnly: true,
                //           maxLines: 3,
                //           controller: TextEditingController(
                //               text: ed25519!.getAddress().toString()),
                //           decoration: InputDecoration(
                //             labelText: "Sui Wallet",
                //             filled: true,
                //             fillColor: Colors.black,
                //             border: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                 width: 1,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // if (solanaAddress.value.isNotEmpty) SizedBox(height: 20),
                // if (solanaAddress.value.isNotEmpty)
                //   Row(
                //     children: [
                //       Image.asset(
                //         "assets/solo.png",
                //         width: 40,
                //       ),
                //       SizedBox(width: 5),
                //       Obx(() => Expanded(
                //             child: TextField(
                //               readOnly: true,
                //               maxLines: 2,
                //               controller: TextEditingController(
                //                   text: solanaAddress.value.toString()),
                //               decoration: InputDecoration(
                //                 labelText: "Solana Wallet",
                //                 filled: true,
                //                 fillColor: Colors.black,
                //                 border: OutlineInputBorder(
                //                   borderSide: BorderSide(
                //                     width: 1,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           )),
                //     ],
                //   ),
                // SizedBox(height: 20),
                // if (evmWalletAddress != null)
                //   Row(
                //     children: [
                //       Image.asset(
                //         "assets/evm.png",
                //         width: 30,
                //       ),
                //       SizedBox(width: 15),
                //       Expanded(
                //         child: TextField(
                //           readOnly: true,
                //           maxLines: 2,
                //           controller: TextEditingController(
                //               text: evmWalletAddress.toString()),
                //           decoration: InputDecoration(
                //             labelText: "EVM Address",
                //             filled: true,
                //             fillColor: Colors.black,
                //             border: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                 width: 1,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // SizedBox(height: 20),
                // if (aptosWalletAddress != null)
                //   Row(
                //     children: [
                //       Image.asset(
                //         "assets/app.png",
                //         width: 40,
                //         height: 40,
                //       ),
                //       SizedBox(width: 5),
                //       Expanded(
                //         child: TextField(
                //           readOnly: true,
                //           maxLines: 2,
                //           controller: TextEditingController(
                //               text: aptosWalletAddress.toString()),
                //           decoration: const InputDecoration(
                //             labelText: "APTOS Wallet",
                //             filled: true,
                //             fillColor: Colors.black38,
                //             border: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                 width: 1,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // const SizedBox(height: 20),
                Obx(() => (profileController.profileModel.value.payload !=
                            null &&
                        profileController.profileModel.value.payload!.email !=
                            null)
                    ? TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: profileController
                              .profileModel.value.payload!.email
                              .toString(),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                        ),
                      )
                    : SizedBox()),
                if (box!.get("solanaAddress") == null)
                  Expanded(
                      child: SubscriptionScreen(
                    showAppbar: false,
                  )),
                if (box!.get("solanaAddress") != null)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Your Preferred Wallet",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      WalletDropdown(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
