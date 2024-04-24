import 'dart:developer';

import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wire/api/api.dart';
import 'package:wire/config/common.dart';
import 'package:wire/view/Onboarding/login_register.dart';
import 'package:wire/view/profile/edit_profile.dart';
import 'package:wire/view/profile/profile_model.dart';
import 'package:wire/view/profile/wifiShare.dart';
import 'package:wire/view/setting/setting.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileModel? profileModel;
  init() async {
    await AndroidFlutterWifi.init();
    apiCall();
  }

  @override
  void initState() {
    init();
    // apiCall();
    super.initState();
  }

  apiCall() async {
    profileModel = await ApiController().getProfile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: profileModel == null
            ? const Center(child: CircularProgressIndicator())
            : profileModel!.payload == null
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profileModel!.payload!.walletAddress != null)
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                profileModel!.payload!.walletAddress.toString(),
                            hintMaxLines: 3,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: profileModel!.payload!.email.toString(),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text("Wifi Connect"),
                        subtitle: const Text("Enable/disable Status"),
                        onTap: () async {
                          var check = await AndroidFlutterWifi.isWifiEnabled();
                          var location =
                              await Permission.location.request().isGranted;
                          log(check.toString());
                          if (check && location) {
                            Get.to(() => const WifiScanP());
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text("Trun on wifi & location"),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text("Ok"),
                                      onPressed: () {
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
                      ListTile(
                        title: const Text("Hotspot"),
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
                          await Permission.location.request();
                          await Permission.locationAlways.request();
                          await Permission.locationWhenInUse.request();
                          // await AndroidFlutterWifi.enableWifi();
                          // var a = await WiFiForIoTPlugin.isWiFiAPEnabled();
                          // var b = await WiFiForIoTPlugin.setEnabled(true);
                          var c = await WiFiForIoTPlugin.setWiFiAPEnabled(true);
                          // log("$c ---   $c");
                        },
                      ),
                      ListTile(
                        title: const Text('Terms and Conditions'),
                        onTap: () {
                          // Navigate to the Terms and Conditions page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TermsAndConditionsPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Privacy Policy'),
                        onTap: () {
                          // Navigate to the Privacy Policy page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Logout'),
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
                    ],
                  ),
      ),
    );
  }
}
