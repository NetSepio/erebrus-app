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
import 'package:wire/view/profile/profile_model.dart';
import 'package:wire/view/profile/wifiShare.dart';
import 'package:wire/view/setting/setting.dart';
import 'package:wire/view/speedCheck/speedCheck.dart';

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
                            labelText: "Wallet Address",
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      // TextField(
                      //   readOnly: true,
                      //   decoration: InputDecoration(
                      //     labelText: profileModel!.payload!.email.toString(),
                      //     border: const OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         width: 1,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const Card(
                        child: ListTile(
                          title: Text("Profile"),
                          subtitle: Text("Your Account Information"),
                          trailing:
                              Icon(Icons.person, size: 20, color: Colors.green),
                          // onTap: () => Get.to(() => const SpeedCheck()),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text("SpeedTest"),
                          subtitle: const Text("Check Your Internet Speed"),
                          trailing: const Icon(Icons.speed,
                              size: 20, color: Colors.green),
                          onTap: () => Get.to(() => const SpeedCheck()),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text("Discover WiFi Networks"),
                          subtitle: const Text("Search Public WiFi Around You"),
                          trailing: const Icon(Icons.wifi,
                              color: Colors.blue, size: 20),
                          onTap: () async {
                            var check =
                                await AndroidFlutterWifi.isWifiEnabled();
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
                                    title:
                                        const Text("Turn on WiFi & Location"),
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
                      ),
                      Card(
                        child: ListTile(
                          title: const Text("Share Hotspot"),
                          subtitle: const Text(
                              "Share your Mobile Internet with others"),
                          // leading: Icon(Icons.hts),
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
                            var c =
                                await WiFiForIoTPlugin.setWiFiAPEnabled(true);
                            // log("$c ---   $c");
                          },
                        ),
                      ),

                      Card(
                        child: ListTile(
                          title: const Text("Request Internet"),
                          subtitle: const Text(
                              "Share your Mobile Internet with others"),
                          onTap: () async {},
                        ),
                      ),

                      Divider(
                        height: 50,
                        color: Colors.grey.shade300,
                        endIndent: 10,
                        indent: 10,
                      ),
                      ListTile(
                        title: const Text('Terms and Conditions'),
                        trailing: const Icon(Icons.policy,
                            color: Colors.blue, size: 20),
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
                        trailing: const Icon(Icons.policy,
                            color: Colors.blue, size: 20),
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
                        trailing: const Icon(Icons.delete,
                            size: 20, color: Colors.red),
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
