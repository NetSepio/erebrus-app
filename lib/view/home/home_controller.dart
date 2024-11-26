import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_curve25519/flutter_curve25519.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:wire/api/api.dart';
import 'package:wire/config/secure_storage.dart';
import 'package:wire/model/AllNodeModel.dart';
import 'package:wire/model/CheckSubModel.dart';
import 'package:wire/model/RegisterClientModel.dart';
import 'package:wire/model/erebrus/client_model.dart';
import 'package:wire/view/Onboarding/login_register.dart';
import 'package:wire/view/profile/profile_model.dart';
import 'package:wire/view/vpn/vpn_home.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

class HomeController extends GetxController {
  RxString? collectionId;
  RxInt selectedNFT = 0.obs;
  Rx<ProfileModel>? profileModel;
  RxBool isLoading = true.obs;
  RxString? selectedCountry = "".obs;
  String? selectedCity;
  Map<String, List<AllNPayload>>? countryMap;
  final storage = SecureStorage();
  Rx<AllNPayload> selectedPayload = AllNPayload().obs;
  Map<String, String> countryCodes = {
    "IN": "India",
    "SG": "Singapore",
    "SE": "Sweden",
    "US": "United States",
    "AU": "Australia",
    "JP": "Japan",
    "CA": "Canada",
    "DE": "Denmark",
    "GB": "United Kingdom",
  };

  Map<String, List<AllNPayload>> groupNodesByCountry(List<AllNPayload> nodes) {
    Map<String, List<AllNPayload>> countryMap = {};
    for (var node in nodes) {
      if (!countryMap.containsKey(node.ipinfocountry)) {
        countryMap[node.ipinfocountry!] = [];
      }
      countryMap[node.ipinfocountry]!.add(node);
    }
    if (selectedPayload.value.region == null) {
      selectedPayload.value = allNodeModel.value.payload![0];
      selectedCountry!.value = countryMap.keys.first;
      selectedCity =
          countryMap[selectedPayload.value.region]!.first.chainName.toString();
    }
    return countryMap;
  }

  getProfileData() async {
    try {
      ProfileModel? result = await ApiController().getProfile();
      isLoading.value = false;
      profileModel = Rx<ProfileModel>(result);
      // if (result.payload != null && result.payload!.walletAddress != null)
      //   box!.put("selectedWalletAddress", result.payload!.walletAddress!);
      update();
    } catch (e) {
      isLoading.value = false;
      Get.offAll(() => const LoginOrRegisterPage());
    }
  }

  Future getPerseto({required String walletAddress}) async {
    try {
      var res = await ApiController().getFlowId(walletAddress: walletAddress);
      isLoading.value = false;
      update();
      return await res;
    } catch (e) {
      isLoading.value = false;
    }
  }

  //.......
  Rx<AllNodeModel> allNodeModel = AllNodeModel().obs;
  Rx<RegisterClientModel> registerClientModel = RegisterClientModel().obs;
  Rx<CheckSubModel> checkSub = CheckSubModel().obs;
  RxMap ipData = {}.obs;
  final wireguard = WireGuardFlutter.instance;

  String initName = 'App';
  String initAddress = "";
  String initPort = "51820";
  String initDnsServer = "1.1.1.1";
  String initPrivateKey = "";
  String initAllowedIp = "0.0.0.0/0, ::/0";
  String initPublicKey = "";
  String initEndpoint = "";
  String presharedKey = '';

  ClientPayload? payload;
  getIp() async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      ipData.value = await ipAddress.getIpAddress();
      log("Ip Update --${ipData.values}");
      update();
    } on IpAddressException catch (exception) {
      print(exception.message);
    }
  }

  getAllNode() async {
    allNodeModel.value = await ApiController().getAllNode();
    countryMap ??= await groupNodesByCountry(allNodeModel.value.payload!);
    // allNodeModel.value.payload!
    //     .removeWhere((element) => element.status == "inactive");
    update();
    checkSubscription();
  }

  checkSubscription() async {
    checkSub.value = await ApiController().checkSubscription();
    getIp();
    update();
  }

  initvpn() async {
    await wireguard.initialize(interfaceName: initName);
  }

  void generateKeyPair() {
    final random = math.Random.secure();
    List<int> seed = List<int>.generate(32, (index) => random.nextInt(256));
    final keypair = Curve25519KeyPair.fromSeed(Uint8List.fromList(seed));
    final keypair1 = Curve25519KeyPair.fromSeed(keypair.privateKey);
    final keypair2 = Curve25519KeyPair.fromSeed(keypair.privateKey);
    print("keypair1  ${base64.encode(keypair1.privateKey)}");
    print("keypair2 ${base64.encode(keypair2.publicKey)}");

    initPublicKey = base64.encode(keypair1.publicKey);
    initPrivateKey = base64.encode(keypair2.privateKey);
    presharedKey =
        base64.encode(Curve25519KeyPair.fromSeed(keypair.privateKey).publicKey);
    getAllNode();

    // apiCall();
    // update();
  }

  apiCall() async {
    EasyLoading.show();
    if (selectedPayload.value.region != null) {
      await ApiController()
          .getVpnData(
              selectedString: selectedPayload.value.region.toString(),
              collectionId: collectionId!.value,
              privateKey: initPublicKey)
          .then((ClientPayload value) {
        payload = value;
        initAddress = payload!.client!.address!.first;
        initAllowedIp =
            "${payload!.client!.allowedIPs!.first}, ${payload!.client!.allowedIPs![1]}";
        initPublicKey = payload!.serverPublicKey!;
        initEndpoint = "${payload!.endpoint}:51820";
        presharedKey = payload!.client!.presharedKey!;
        update();
        startVpn();
      });
    }

    update();
  }

  Future startVpn() async {
    var conf = '''[Interface]
                PrivateKey = $initPrivateKey
                Address = $initAddress
                DNS = 1.1.1.1

                [Peer]
                PublicKey = $initPublicKey
                PresharedKey = $presharedKey
                AllowedIPs = 0.0.0.0/0, ::/0
                PersistentKeepalive = 16
                Endpoint = $initEndpoint
                ''';
    log("vpn conf -- $conf");
    try {
      await wireguard.startVpn(
        serverAddress: initEndpoint,
        wgQuickConfig: conf,
        providerBundleIdentifier: 'com.erebrus.app.VPNExtension',
        // providerBundleIdentifier: 'com.esoft.reward.WGExtension',
      );
      EasyLoading.dismiss();
      vpnActivate.value = true;
      getIp();
    } catch (error, stack) {
      vpnActivate.value = false;
      debugPrint("failed to start $error\n$stack");
    }
    update();
  }

  void disconnect() async {
    try {
      await wireguard.stopVpn();
      vpnActivate.value = false;
      if (registerClientModel.value.payload != null) {
        await ApiController().deleteVpn2(
            uuid: registerClientModel.value.payload!.client!.uuid!,
            region: selectedPayload.value.region.toString().toLowerCase());
      } else {
        await ApiController()
            .deleteVpn(uuid: registerClientModel.value.payload!.client!.uuid!);
      }
      log("vpnActivate.value --   ${vpnActivate.value}");
      update();
    } catch (e, str) {
      debugPrint('Failed to disconnect $e\n$str');
    }
  }

  registerClient() async {
    log("initPublicKey -- $initPublicKey");
    log("presharedKey -- $presharedKey");
    EasyLoading.show();
    registerClientModel.value = await ApiController().registerClient(
        selectedPayload.value.id.toString(), initPublicKey, initPrivateKey);
    if (registerClientModel.value.payload == null) {
      Fluttertoast.showToast(
          msg: "Something went wrong. Please try another region.");
      return;
    }
    RegisterPayload vpnData = registerClientModel.value.payload!;
    initAddress = vpnData.client!.address!.first;
    initAllowedIp =
        "${vpnData.client!.allowedIPs!.first}, ${vpnData.client!.allowedIPs![1]}";
    initPublicKey = vpnData.serverPublicKey!;
    initEndpoint = "${vpnData.endpoint}:51820";
    presharedKey = vpnData.client!.presharedKey!;
    update();
    startVpn();
  }
}
