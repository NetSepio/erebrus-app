import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/strings.dart';
import 'package:erebrus_app/view/Onboarding/login_register.dart';
import 'package:erebrus_app/view/profile/profile.dart';
import 'package:erebrus_app/view/settings/privacyPolicy.dart';
import 'package:erebrus_app/view/speedCheck/speedCheck.dart';
import 'package:erebrus_app/view/subscription/subscriptionScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  // PackageInfo? packageInfo;

  bool? _serviceEnabled;
  LocationData? _locationData;
  init() async {
    // await AndroidFlutterWifi.init();
    // packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  @override
  void initState() {
    init();
    // apiCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  trailing:
                      const Icon(Icons.person, size: 20, color: Colors.green),
                  onTap: () => Get.to(
                      () => Profile(title: profileTxt, showBackArrow: true)),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text(speedTestTxt),
                  subtitle: const Text(speedTestSubTxt),
                  trailing:
                      const Icon(Icons.speed, size: 20, color: Colors.green),
                  onTap: () => Get.to(() => const SpeedCheck()),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Subscription"),
                  subtitle:
                      const Text("Access premium VPN and enhanced security"),
                  // trailing:
                  //     const Icon(Icons.subscriptions, size: 20, color: Colors.green),
                  onTap: () {
                    Get.to(() => SubscriptionScreen());
                  },
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
                          onPressed: () {
                            Navigator.pop(context);
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
              const SizedBox(height: 30),
              // if (packageInfo != null)
              //   Center(
              //       child: Text(
              //           "V. ${packageInfo!.version.toString()}+${packageInfo!.buildNumber}"))
            ],
          ),
        ),
      ),
    );
  }
}
