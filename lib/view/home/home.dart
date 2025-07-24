import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:erebrus_app/api/api.dart';
import 'package:erebrus_app/config/api_const.dart';
import 'package:erebrus_app/config/colors.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/secure_storage.dart';
import 'package:erebrus_app/controller/profileContrller.dart';
import 'package:erebrus_app/model/CheckSubscriptionModel.dart';
import 'package:erebrus_app/model/DVPNNodesModel.dart';
import 'package:erebrus_app/tors.dart';
import 'package:erebrus_app/view/Onboarding/wallet_generator.dart';
import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:erebrus_app/view/profile/profile.dart';
import 'package:erebrus_app/view/settings/SettingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import "package:reown_appkit/reown_appkit.dart";
import 'package:wireguard_flutter/wireguard_flutter.dart';
import 'package:erebrus_app/view/home/server_selection.dart';

RxBool vpnActivate = false.obs;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

ProfileController profileController = Get.find();

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();
  RxBool showDummyNft = false.obs;
  final storage = SecureStorage();

  @override
  void initState() {
    homeController.initvpn();
    // walletSelection();

    homeController.wireguard.vpnStageSnapshot.listen((event) {
      debugPrint("status changed $event");
      if (mounted) {
        switch (event) {
          case VpnStage.connected:
            log("connected");
            break;
          case VpnStage.disconnected:
            log("disconnected");
            break;
          default:
        }
      }
    });
    profileCall();
    // Timer(
    //   Duration(seconds: 2),
    //   () {
    //     // showDummyNft.value = true;
    //   },
    // );
    homeController.generateKeyPair();
    super.initState();
  }

  profileCall() async {
    try {
      await profileController.getProfile();
    } catch (e) {}
  }

  walletSelection() async {
    EasyLoading.show();
    var mnemonics = await storage.getStoredValue("mnemonic") ?? "";
    if (mnemonics.isEmpty) {
      EasyLoading.dismiss();
      // await subsTry();
      return;
    }
    profileController.mnemonics.value = mnemonics;
    await profileController.getProfile();
    await getSolanaAddress(mnemonics);
    await suiWal(mnemonics);
    await getEclipseAddress(mnemonics);
    await getSoonAddress(mnemonics);
    await evmAptos(mnemonics);
    setState(() {});

    await Future.delayed(Duration(milliseconds: 50));
    EasyLoading.dismiss();
    if (box!.containsKey("ApiWallet") && box!.get("ApiWallet") != null) {
      if (box!.containsKey("selectedWalletAddress") == false ||
          box!.get("selectedWalletAddress") == null) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 270,
                    width: Get.width,
                    child: Profile(
                      title: "",
                      showBackArrow: false,
                    ),
                  ),
                  // WalletDropdown(),
                ],
              ),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade700,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      if (box!.containsKey("selectedWalletAddress") &&
                          box!.get("selectedWalletAddress") != null) {
                        Get.back();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Select Wallet",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red);
                      }
                    },
                    child: Center(child: Text("Ok"))),
              ],
            );
          },
        );
      }
    }
    await subsTry();
  }

  subsTry() async {
    bool firs = await box!.containsKey("FirstTime");
    CheckSubscriptionModel? checkSub =
        await ApiController().checkSubscription();
    if (checkSub.subscription == null) {
      if (!firs) {
        box!.put("FirstTime", true);
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Try Our Free Subscription",
                textAlign: TextAlign.center,
              ),
              content: Text(
                "Unleash the power of future internet with our ÐVPN and ÐWi-Fi",
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Cancel")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            foregroundColor: Colors.white),
                        onPressed: () async {
                          EasyLoading.show();
                          try {
                            await ApiController().trialSubscription();
                            await ApiController().checkSubscription();
                            await walletSelection();
                            EasyLoading.dismiss();
                          } catch (e) {
                            EasyLoading.dismiss();
                          }
                          Get.back();
                        },
                        child: Text("Subscribe")),
                  ],
                )
              ],
            );
          },
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    log("-------  ------ didChangeDependencies");
    homeController.generateKeyPair();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (vpnActivate.value == true) {
          // Connected state UI
          return ConnectedStateScreen();
        } else {
          // Main screen UI (as before)
          final homeController = Get.find<HomeController>();
          final ip = homeController.selectedPayload.value.ipinfoip ??
              homeController.ipData['ip'] ??
              '0.0.0.0';
          final downloadSpeed =
              homeController.selectedPayload.value.downloadSpeed;
          final uploadSpeed = homeController.selectedPayload.value.uploadSpeed;
          return VpnHomeContent(
            isConnected: false,
            onPowerTap: () {
              if (vpnActivate.value == true) {
                homeController.generateKeyPair();
                homeController.disconnect();
                homeController.getIp();
                return;
              }
              if (homeController.checkSub.value.status == "notFound") {
                Fluttertoast.showToast(
                    msg: "Check Your Subscription",
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red);
                return;
              }
              if (vpnActivate.value == false) {
                if (homeController.collectionId != null &&
                    homeController.selectedNFT.value != 0) {
                  homeController.apiCall();
                } else {
                  homeController.registerClient();
                }
              }
              homeController.getIp();
            },
            timerString: '00:00:00',
            ip: ip,
            downloadSpeed: downloadSpeed,
            uploadSpeed: uploadSpeed,
            serverInfoCard: _buildServerInfoCard(context, homeController),
          );
        }
      }),
    );
  }
}

class VpnHomeContent extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onPowerTap;
  final String timerString;
  final String ip;
  final double? downloadSpeed;
  final double? uploadSpeed;
  final Widget serverInfoCard;

  const VpnHomeContent({
    Key? key,
    required this.isConnected,
    required this.onPowerTap,
    required this.timerString,
    required this.ip,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.serverInfoCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.to(() => TorHome());
                },
                child: Text("data")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/erebrus_mobile_app_icon.png',
                  height: 28,
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      'EREBRUS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'VPN',
                      style: TextStyle(
                        color: Color(0xFF1E90FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => SettingPage());
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            Spacer(),
            Text(
              isConnected ? 'Connected' : '',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              timerString,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  letterSpacing: 2),
            ),
            SizedBox(height: 50),
            Center(
              child: InkWell(
                onTap: onPowerTap,
                borderRadius: BorderRadius.circular(90),
                child: AvatarGlow(
                  glowColor: isConnected
                      ? Colors.green
                      : const Color.fromRGBO(37, 112, 252, 1),
                  duration: const Duration(milliseconds: 2000),
                  repeat: isConnected,
                  animate: isConnected,
                  glowShape: BoxShape.circle,
                  child: Material(
                    elevation: 0,
                    shape: const CircleBorder(),
                    color: isConnected ? Colors.green : const Color(0xff0162FF),
                    child: SizedBox(
                      height: 160,
                      width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.power_settings_new,
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isConnected ? "RUNNING" : 'CONNECT',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Obx(
              () => (vpnActivate.value)
                  ? Text('Your IP: $ip',
                      style: TextStyle(color: Colors.white, fontSize: 16))
                  : SizedBox(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF181A20),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_downward,
                              color: Colors.white, size: 20),
                          SizedBox(width: 6),
                          Text(
                            downloadSpeed != null
                                ? '${downloadSpeed!.toStringAsFixed(1)} Mb/s '
                                : '-- Mb/s',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('Downloaded',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white24,
                ),
                Container(
                  width: 160,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF181A20),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_upward,
                              color: Colors.white, size: 20),
                          SizedBox(width: 6),
                          Text(
                            uploadSpeed != null
                                ? '${uploadSpeed!.toStringAsFixed(1)} Mb/s'
                                : '-- Mb/s',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('Uploaded',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            serverInfoCard,
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class ConnectedStateScreen extends StatefulWidget {
  const ConnectedStateScreen({Key? key}) : super(key: key);

  @override
  State<ConnectedStateScreen> createState() => _ConnectedStateScreenState();
}

class _ConnectedStateScreenState extends State<ConnectedStateScreen> {
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get timerString {
    final hours = (_seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final ip = homeController.selectedPayload.value.ipinfoip ??
        homeController.ipData['ip'] ??
        '0.0.0.0';
    final downloadSpeed = homeController.selectedPayload.value.downloadSpeed;
    final uploadSpeed = homeController.selectedPayload.value.uploadSpeed;
    return VpnHomeContent(
      isConnected: true,
      onPowerTap: () {
        homeController.disconnect();
      },
      timerString: timerString,
      ip: ip,
      downloadSpeed: downloadSpeed,
      uploadSpeed: uploadSpeed,
      serverInfoCard: _buildServerInfoCard(context, homeController),
    );
  }
}

Widget _buildServerInfoCard(
    BuildContext context, HomeController homeController) {
  final selected = homeController.selectedPayload.value;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Container(
      decoration: BoxDecoration(
        color: Color(0xFF181A20),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          if (selected.ipinfocountry != null)
            Text(
              countryCodeToEmoji(selected.ipinfocountry.toString()),
              style: TextStyle(fontSize: 28),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  homeController.countryCodes[
                          selected.ipinfocountry?.toUpperCase() ?? ''] ??
                      selected.ipinfocountry?.toUpperCase() ??
                      '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Secure Network',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.network_check, color: Colors.green, size: 18),
              const SizedBox(width: 4),
              Text(
                '168ms', // TODO: Replace with actual ping if available
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: () {
              Get.to(() => ServerSelectionScreen());
            },
            child: Row(
              children: [
                Text('Change', style: TextStyle(color: Color(0xFF1E90FF))),
                Icon(Icons.arrow_forward_ios,
                    color: Color(0xFF1E90FF), size: 16),
              ],
            ),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF1E90FF),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
          ),
        ],
      ),
    ),
  );
}
