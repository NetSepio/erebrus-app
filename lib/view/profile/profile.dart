import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/strings.dart';
import 'package:erebrus_app/config/responsive.dart';
import 'package:erebrus_app/controller/profileContrller.dart';
import 'package:erebrus_app/main.dart';
import 'package:erebrus_app/view/Onboarding/wallet_generator.dart';
import 'package:erebrus_app/view/profile/walletSelection.dart';
import 'package:erebrus_app/view/settings/SettingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  final String title;
  final bool showBackArrow;
  final bool showSubscription;

  const Profile(
      {super.key,
      required this.title,
      required this.showBackArrow,
      this.showSubscription = false});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  RxString solanaAddress = "".obs;
  final storage = box;
  ProfileController profileController = Get.find();
  config() async {}

  apiCall() async {
    try {
      config();
      await profileController.getProfile();
      // var mnemonics = await profileController.mnemonics.value;
      // await getSolanaAddress(mnemonics);
      // if (appEnvironmentFor != "saga") {
      //   await suiWal(mnemonics);
      //   await getEclipseAddress(mnemonics);
      //   await getSoonAddress(mnemonics);
      //   await evmAptos(mnemonics);
      // }
    } catch (e) {}
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
          title: Text(widget.title, style: TextStyle(fontSize: Responsive.scaleText(context, 20))),
          centerTitle: true,
          actions: [
            if (widget.showSubscription)
              InkWell(
                onTap: () {
                  Get.to(() => const SettingPage())!.whenComplete(
                    () {
                      setState(() {});
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(Responsive.scaleWidth(context, 8.0)),
                  child: Icon(Icons.settings, size: Responsive.scaleWidth(context, 24)),
                ),
              )
          ],
          automaticallyImplyLeading: widget.showBackArrow ? true : false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: [
                if (widget.title == "EREBRUS" || widget.title == profileTxt)
                  Obx(() => (profileController.profileModel.value.payload !=
                              null &&
                          profileController.profileModel.value.payload!.name !=
                              null &&
                          profileController
                              .profileModel.value.payload!.name!.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            readOnly: true,
                            onTap: null,
                            controller: TextEditingController(
                                text: profileController
                                    .profileModel.value.payload!.name
                                    .toString()),
                            decoration: InputDecoration(
                              labelText: "Name",
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox()),
                if (widget.title == "EREBRUS" || widget.title == profileTxt)
                  Obx(() => (profileController.profileModel.value.payload !=
                              null &&
                          profileController.profileModel.value.payload!.email !=
                              null &&
                          profileController
                              .profileModel.value.payload!.email!.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            readOnly: true,
                            onTap: null,
                            controller: TextEditingController(
                                text: profileController
                                    .profileModel.value.payload!.email
                                    .toString()),
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox()),
                if (widget.title == "EREBRUS" || widget.title == profileTxt)
                  Obx(() => (profileController.profileModel.value.payload !=
                              null &&
                          profileController.profileModel.value.payload!.apple !=
                              null &&
                          profileController
                              .profileModel.value.payload!.apple!.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            readOnly: true,
                            onTap: null,
                            controller: TextEditingController(
                                text: profileController
                                    .profileModel.value.payload!.apple
                                    .toString()),
                            decoration: InputDecoration(
                              labelText: "Apple",
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox()),
                if (widget.title == "EREBRUS" || widget.title == profileTxt)
                  Obx(() =>
                      (profileController.profileModel.value.payload != null &&
                              profileController
                                      .profileModel.value.payload!.google !=
                                  null &&
                              profileController.profileModel.value.payload!
                                  .google!.isNotEmpty)
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                readOnly: true,
                                onTap: null,
                                controller: TextEditingController(
                                    text: profileController
                                        .profileModel.value.payload!.google
                                        .toString()),
                                decoration: InputDecoration(
                                  labelText: "Google",
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox()),
                if (widget.title == "EREBRUS" || widget.title == profileTxt)
                  Obx(() => (profileController.profileModel.value.payload !=
                              null &&
                          profileController
                                  .profileModel.value.payload!.walletAddress !=
                              null)
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            readOnly: true,
                            onTap: null,
                            maxLines: 4,
                            minLines: 1,
                            controller: TextEditingController(
                              text: box!.containsKey("selectedWalletAddress") &&
                                      box!.get("selectedWalletAddress") != null
                                  ? box!.get("selectedWalletAddress").toString()
                                  : profileController
                                      .profileModel.value.payload!.walletAddress
                                      .toString(),
                            ),
                            decoration: InputDecoration(
                              prefixIcon: appEnvironmentFor == "saga"
                                  ? Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        "assets/solo.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                    )
                                  : null,
                              labelText: appEnvironmentFor == "saga"
                                  ? "Solana Wallet Address"
                                  : "Wallet Address",
                              suffixIcon: InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(ClipboardData(
                                        text: box!.containsKey(
                                                    "selectedWalletAddress") &&
                                                box!.get(
                                                        "selectedWalletAddress") !=
                                                    null
                                            ? box!
                                                .get("selectedWalletAddress")
                                                .toString()
                                            : profileController.profileModel
                                                .value.payload!.walletAddress
                                                .toString()));
                                    Fluttertoast.showToast(msg: "Copied");
                                  },
                                  child: Icon(Icons.copy)),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox()),
                Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Your Web3 Wallet",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    WalletDropdown(
                      onChanged: (p0) {
                        setState(() {});
                      },
                      fromProfileScreen: widget.title == "Profile",
                    ),
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
