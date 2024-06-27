import 'dart:developer';

import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wire/config/common.dart';
import 'package:wire/view/Onboarding/login_register.dart';
import 'package:wire/view/profile/profile.dart';
import 'package:wire/view/profile/wifiShare.dart';
import 'package:wire/view/setting/PrivacyPolicy.dart';
import 'package:wire/view/speedCheck/speedCheck.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Location location = Location();
  PackageInfo? packageInfo;

  bool? _serviceEnabled;
  LocationData? _locationData;
  init() async {
    await AndroidFlutterWifi.init();

    packageInfo = await PackageInfo.fromPlatform();
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
        actions: const [
          // IconButton(
          //   icon: const Icon(Icons.edit),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const EditProfilePage(),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text("Profile"),
                subtitle: const Text("Your Account Information"),
                trailing:
                    const Icon(Icons.person, size: 20, color: Colors.green),
                onTap: () => Get.to(() => const Profile()),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("SpeedTest"),
                subtitle: const Text("Check Your Internet Speed"),
                trailing:
                    const Icon(Icons.speed, size: 20, color: Colors.green),
                onTap: () => Get.to(() => const SpeedCheck()),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Discover WiFi Networks"),
                subtitle: const Text("Search Public WiFi Around You"),
                trailing: const Icon(Icons.wifi, color: Colors.blue, size: 20),
                onTap: () async {
                  var check = await AndroidFlutterWifi.isWifiEnabled();
                  AndroidFlutterWifi.enableWifi();

                  // await WiFiForIoTPlugin.forceWifiUsage(true);
                  var location = await Permission.location.request().isGranted;
                  log(check.toString());
                  if (check && location) {
                    Get.to(() => const WifiScanP());
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text("Turn on WiFi & Location"),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text("Ok"),
                              onPressed: () {
                                WiFiForIoTPlugin.setEnabled(true,
                                    shouldOpenSettings: true);
                                Get.back();
                              },
                            )
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Share Hotspot"),
                subtitle: const Text("Share your Mobile Internet with others"),
                trailing: Image.asset(
                  "assets/hotspot.png",
                  height: 20,
                  color: Colors.grey,
                ),
                //   subtitle: StreamBuilder(
                //       stream: AndroidFlutterWifi.isWifiEnabled().asStream(),
                //       builder: (context, snapshot) {
                //         if (snapshot.data == null) {
                //           return const Text("data");
                //         }
                //         log("isWifiEnabled -- ${snapshot.data}");
                //         return CupertinoSwitch(
                //             value: snapshot.data!,
                //             onChanged: (value) async {
                //               if (!value) {
                //                 await AndroidFlutterWifi.disableWifi();
                //               } else {
                //                 log("message");
                //                 await AndroidFlutterWifi.enableWifi();
                //               }
                //             });
                //       }),
                onTap: () async {
                  // await Permission.location.request();
                  // await Permission.locationAlways.request();
                  // await Permission.locationWhenInUse.request();
                  // await AndroidFlutterWifi.enableWifi();
                  // var a = await WiFiForIoTPlugin.isWiFiAPEnabled();
                  // var b = await WiFiForIoTPlugin.setEnabled(true);
                  await location.requestPermission();
                  _serviceEnabled = await location.serviceEnabled();
                  _serviceEnabled = await location.requestService();
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text("You will disconnect from your wifi"),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      var c = await WiFiForIoTPlugin
                                          .setWiFiAPEnabled(true);
                                    } catch (e) {
                                      log("HOTSPORT E_-$e");
                                    }
                                    Get.back();
                                  },
                                  child: const Text("Connect")),
                            ],
                          ),
                        ],
                      );
                    },
                  );

                  // log("$c ---   $c");
                },
              ),
            ),
            // Card(
            //   child: ListTile(
            //     title: const Text("Request Internet"),
            //     onTap: () async {},
            //   ),
            // ),
            Divider(
              height: 50,
              color: Colors.grey.shade300,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: const Text('Terms and Conditions'),
              trailing: const Icon(Icons.policy, color: Colors.blue, size: 20),
              onTap: () {
                launchUrl(Uri.parse("https://erebrus.io/terms"));
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.policy, color: Colors.blue, size: 20),
              onTap: () {
                Get.to(() => const PrivacyPolicy());
                // launchUrl(Uri.parse("https://netsepio.com/privacy.html"));
              },
            ),
            ListTile(
              title: const Text('Logout'),
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
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
              trailing: const Icon(Icons.delete, size: 20, color: Colors.red),
              onTap: () {
                // Display a confirmation dialog before deleting the account
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text(
                        'Are you sure you want to delete your account?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement your delete account logic here
                          Navigator.pop(context); // Close the dialog
                          // After deleting the account, you can navigate to the login page or perform any other action
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            if (packageInfo != null)
              Center(
                  child: Text(
                      "V. ${packageInfo!.version.toString()}+${packageInfo!.buildNumber}"))
          ],
        ),
      ),
    );
  }
}
