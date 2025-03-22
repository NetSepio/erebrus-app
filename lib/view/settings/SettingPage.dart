import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/secure_storage.dart';
import 'package:erebrus_app/config/strings.dart';
import 'package:erebrus_app/main.dart';
import 'package:erebrus_app/view/Onboarding/login_register.dart';
import 'package:erebrus_app/view/Onboarding/wallet_generator.dart';
import 'package:erebrus_app/view/Perks/PerksScreen.dart';
import 'package:erebrus_app/view/inAppPurchase/ProFeaturesScreen.dart';
import 'package:erebrus_app/view/profile/profile.dart';
import 'package:erebrus_app/view/settings/privacyPolicy.dart';
import 'package:erebrus_app/view/speedCheck/speedCheck.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Location location = Location();
  init() async {
    // await AndroidFlutterWifi.init();
    // packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  @override
  void initState() {
    init();
    apiCall();
    super.initState();
  }

  apiCall() async {
    EasyLoading.show();
    final storage = SecureStorage();
    try {
      var mnemonics = await storage.getStoredValue("mnemonic") ?? "";
      await getSolanaAddress(mnemonics);
      await suiWal(mnemonics);
      await getEclipseAddress(mnemonics);
      await getSoonAddress(mnemonics);
      await evmAptos(mnemonics);
    } catch (e) {
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${packageInfo!.version}+${packageInfo!.buildNumber} "),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ElevatedButton(
              //     onPressed: () {
              //       Get.to(() => VoiceChatBot());
              //     },
              //     child: Text("data")),
              Card(
                child: ListTile(
                  title: const Text(profileTxt),
                  subtitle: const Text(profileSubTxt),
                  leading: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.purple.shade800,
                        Colors.purple.shade300,
                      ]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child:
                        const Icon(Icons.person, size: 20, color: Colors.white),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () => Get.to(() => Profile(
                        title: profileTxt,
                        showBackArrow: true,
                      )),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Perq"),
                  subtitle: const Text("--- --- "),
                  leading: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.blueAccent.shade700,
                        Colors.blue.shade300,
                      ], end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: const Icon(Icons.subscriptions_outlined,
                        size: 20, color: Colors.white),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () {
                    Get.to(() => PerksScreen());
                  },
                ),
              ),

              // Card(
              //   child: ListTile(
              //     title: const Text("Discover WIFI"),
              //     subtitle: const Text("Find nearby WIFI"),
              //     leading: Container(
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(colors: [
              //           Colors.green.shade800,
              //           Colors.green.shade300,
              //         ], end: Alignment.bottomRight),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       padding: EdgeInsets.all(10),
              //       child: const Icon(Icons.wifi_find_rounded,
              //           size: 20, color: Colors.white),
              //     ),
              //     trailing: Icon(Icons.arrow_forward_ios, size: 20),
              //     onTap: () => Get.to(() => const MapSample()),
              //   ),
              // ),
              Card(
                child: ListTile(
                  title: const Text("Mode"),
                  subtitle: const Text("Basic Mode/Pro Mode"),
                  leading: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.green.shade800,
                        Colors.green.shade300,
                      ], end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: const Icon(Icons.wifi_find_rounded,
                        size: 20, color: Colors.white),
                  ),
                  trailing: CupertinoSwitch(
                    value: box!.get("appMode") == null ||
                            box!.get("appMode") == "basic"
                        ? false
                        : true,
                    onChanged: (value) {
                      if (value) {
                        box!.put("appMode", 'pro');
                      } else {
                        box!.put("appMode", 'basic');
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),

              // if (Platform.isIOS)
              Card(
                child: ListTile(
                  title: const Text("Subscription"),
                  subtitle:
                      const Text("Access premium VPN and enhanced security"),
                  leading: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.deepOrange.shade800,
                        Colors.deepOrange.shade300,
                      ], end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: const Icon(Icons.subscriptions_outlined,
                        size: 20, color: Colors.white),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () {
                    // Get.to(() => FreeTrialButton());
                    Get.to(() => ProFeaturesScreen(
                          fromLogin: false,
                        ));
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text(speedTestTxt),
                  subtitle: const Text(speedTestSubTxt),
                  leading: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.blue.shade800,
                        Colors.blue.shade300,
                      ], end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child:
                        const Icon(Icons.speed, size: 20, color: Colors.white),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () => Get.to(() => const SpeedCheck()),
                ),
              ),

              Divider(
                height: 50,
                color: Colors.grey.shade300,
                endIndent: 10,
                indent: 10,
              ),
              ListTile(
                title: const Text(termsAndConditionsText),
                trailing: const Icon(Icons.policy,
                    color: Color(0xff0162FF), size: 20),
                onTap: () {
                  launchUrl(Uri.parse("https://erebrus.io/terms"));
                },
              ),
              ListTile(
                title: const Text(privacyPolicy),
                trailing: const Icon(Icons.policy,
                    color: Color(0xff0162FF), size: 20),
                onTap: () {
                  Get.to(() => const PrivacyPolicy());
                  // launchUrl(Uri.parse("https://netsepio.com/privacy.html"));
                },
              ),
              ListTile(
                title: const Text(logoutTxt),
                trailing: const Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 20,
                ),
                onTap: () async {
                  await box!.clear();
                  await box!.close();
                  box = await Hive.openBox('erebrus');
                  Get.offAll(() => const LoginOrRegisterPage());
                },
              ),
              ListTile(
                title: const Text(
                  deleteAccountTxt,
                  style: TextStyle(color: Colors.red),
                ),
                trailing: const Icon(Icons.delete, size: 20, color: Colors.red),
                onTap: () {
                  // Display a confirmation dialog before deleting the account
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(deleteAccountTxt),
                      content: const Text(deleteAccountSubTxt),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await box!.clear();
                            Get.offAll(() => const LoginOrRegisterPage());
                          },
                          child: const Text(cancelTxt),
                        ),
                        TextButton(
                          onPressed: () async {
                            await box!.clear();
                            Get.offAll(() => const LoginOrRegisterPage());
                          },
                          child: const Text(
                            deleteTxt,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
