import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:erebrus_app/api/api.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/model/CheckSubscriptionModel.dart';
import 'package:erebrus_app/model/DVPNNodesModel.dart';
import 'package:erebrus_app/model/RegisterVPNClientModel.dart';
import 'package:erebrus_app/model/erebrus/client_model.dart';
import 'package:erebrus_app/view/Onboarding/login_register.dart';
import 'package:erebrus_app/view/profile/profile_model.dart';
import 'package:erebrus_app/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curve25519/flutter_curve25519.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

class HomeController extends GetxController {
  RxString? collectionId;
  RxInt selectedNFT = 0.obs;
  Rx<ProfileModel>? profileModel;
  RxBool isLoading = true.obs;
  RxString? selectedNode = "".obs;
  String? selectedCity;
  Map<String, List<AllNPayload>>? countryMap;
  String sNodeid = '';
  int vpnConnectAttempt = 0;

  final storage = box;
  Rx<AllNPayload> selectedPayload = AllNPayload().obs;
  Map<String, String> countryCodes = {
    "AF": "Afghanistan",
    "AL": "Albania",
    "DZ": "Algeria",
    "AS": "American Samoa",
    "AD": "Andorra",
    "AO": "Angola",
    "AI": "Anguilla",
    "AG": "Antigua and Barbuda",
    "AR": "Argentina",
    "AM": "Armenia",
    "AW": "Aruba",
    "AU": "Australia",
    "AT": "Austria",
    "AZ": "Azerbaijan",
    "BS": "Bahamas",
    "BH": "Bahrain",
    "BD": "Bangladesh",
    "BB": "Barbados",
    "BY": "Belarus",
    "BE": "Belgium",
    "BZ": "Belize",
    "BJ": "Benin",
    "BM": "Bermuda",
    "BT": "Bhutan",
    "BO": "Bolivia",
    "BA": "Bosnia and Herzegovina",
    "BW": "Botswana",
    "BR": "Brazil",
    "BN": "Brunei",
    "BG": "Bulgaria",
    "BF": "Burkina Faso",
    "BI": "Burundi",
    "CV": "Cabo Verde",
    "KH": "Cambodia",
    "CM": "Cameroon",
    "CA": "Canada",
    "KY": "Cayman Islands",
    "CF": "Central African Republic",
    "TD": "Chad",
    "CL": "Chile",
    "CN": "China",
    "CO": "Colombia",
    "KM": "Comoros",
    "CG": "Congo",
    "CD": "Congo (DRC)",
    "CR": "Costa Rica",
    "HR": "Croatia",
    "CU": "Cuba",
    "CY": "Cyprus",
    "CZ": "Czechia",
    "DK": "Denmark",
    "DJ": "Djibouti",
    "DM": "Dominica",
    "DO": "Dominican Republic",
    "EC": "Ecuador",
    "EG": "Egypt",
    "SV": "El Salvador",
    "GQ": "Equatorial Guinea",
    "ER": "Eritrea",
    "EE": "Estonia",
    "SZ": "Eswatini",
    "ET": "Ethiopia",
    "FJ": "Fiji",
    "FI": "Finland",
    "FR": "France",
    "GA": "Gabon",
    "GM": "Gambia",
    "GE": "Georgia",
    "DE": "Germany",
    "GH": "Ghana",
    "GR": "Greece",
    "GD": "Grenada",
    "GU": "Guam",
    "GT": "Guatemala",
    "GN": "Guinea",
    "GW": "Guinea-Bissau",
    "GY": "Guyana",
    "HT": "Haiti",
    "HN": "Honduras",
    "HU": "Hungary",
    "IS": "Iceland",
    "IN": "India",
    "ID": "Indonesia",
    "IR": "Iran",
    "IQ": "Iraq",
    "IE": "Ireland",
    "IL": "Israel",
    "IT": "Italy",
    "JM": "Jamaica",
    "JP": "Japan",
    "JO": "Jordan",
    "KZ": "Kazakhstan",
    "KE": "Kenya",
    "KI": "Kiribati",
    "KW": "Kuwait",
    "KG": "Kyrgyzstan",
    "LA": "Laos",
    "LV": "Latvia",
    "LB": "Lebanon",
    "LS": "Lesotho",
    "LR": "Liberia",
    "LY": "Libya",
    "LI": "Liechtenstein",
    "LT": "Lithuania",
    "LU": "Luxembourg",
    "MG": "Madagascar",
    "MW": "Malawi",
    "MY": "Malaysia",
    "MV": "Maldives",
    "ML": "Mali",
    "MT": "Malta",
    "MH": "Marshall Islands",
    "MR": "Mauritania",
    "MU": "Mauritius",
    "MX": "Mexico",
    "FM": "Micronesia",
    "MD": "Moldova",
    "MC": "Monaco",
    "MN": "Mongolia",
    "ME": "Montenegro",
    "MA": "Morocco",
    "MZ": "Mozambique",
    "MM": "Myanmar",
    "NA": "Namibia",
    "NR": "Nauru",
    "NP": "Nepal",
    "NL": "Netherlands",
    "NZ": "New Zealand",
    "NI": "Nicaragua",
    "NE": "Niger",
    "NG": "Nigeria",
    "NO": "Norway",
    "OM": "Oman",
    "PK": "Pakistan",
    "PW": "Palau",
    "PS": "Palestine",
    "PA": "Panama",
    "PG": "Papua New Guinea",
    "PY": "Paraguay",
    "PE": "Peru",
    "PH": "Philippines",
    "PL": "Poland",
    "PT": "Portugal",
    "QA": "Qatar",
    "RO": "Romania",
    "RU": "Russia",
    "RW": "Rwanda",
    "WS": "Samoa",
    "SM": "San Marino",
    "ST": "Sao Tome and Principe",
    "SA": "Saudi Arabia",
    "SN": "Senegal",
    "RS": "Serbia",
    "SC": "Seychelles",
    "SL": "Sierra Leone",
    "SG": "Singapore",
    "SK": "Slovakia",
    "SI": "Slovenia",
    "SB": "Solomon Islands",
    "SO": "Somalia",
    "ZA": "South Africa",
    "KR": "South Korea",
    "ES": "Spain",
    "LK": "Sri Lanka",
    "SD": "Sudan",
    "SR": "Suriname",
    "SE": "Sweden",
    "CH": "Switzerland",
    "SY": "Syria",
    "TW": "Taiwan",
    "TJ": "Tajikistan",
    "TZ": "Tanzania",
    "TH": "Thailand",
    "TL": "Timor-Leste",
    "TG": "Togo",
    "TO": "Tonga",
    "TT": "Trinidad and Tobago",
    "TN": "Tunisia",
    "TR": "Turkey",
    "TM": "Turkmenistan",
    "TV": "Tuvalu",
    "UG": "Uganda",
    "UA": "Ukraine",
    "AE": "United Arab Emirates",
    "GB": "United Kingdom",
    "US": "United States",
    "UY": "Uruguay",
    "UZ": "Uzbekistan",
    "VU": "Vanuatu",
    "VE": "Venezuela",
    "VN": "Vietnam",
    "YE": "Yemen",
    "ZM": "Zambia",
    "ZW": "Zimbabwe"
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
      selectedNode!.value = countryMap.keys.first;
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
      if (result.payload != null && result.payload!.walletAddress != null)
        box!.put("ApiWallet", result.payload!.walletAddress!);
      update();
    } catch (e) {
      isLoading.value = false;
      Get.offAll(() => const LoginOrRegisterPage());
    }
  }

  Future getPASETO(
      {required String walletAddress, required String chain}) async {
    try {
      var res = await ApiController()
          .getFlowId(walletAddress: walletAddress, chain: chain);
      EasyLoading.dismiss();
      isLoading.value = false;
      update();
      return await res;
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  //.......
  Rx<DVPNNodesModel> allNodeModel = DVPNNodesModel().obs;
  Rx<RegisterClientModel> registerClientModel = RegisterClientModel().obs;
  Rx<CheckSubscriptionModel> checkSub = CheckSubscriptionModel().obs;
  RxMap ipData = {}.obs;
  final wireguard = WireGuardFlutter.instance;

  String initName = 'Erebrus';
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
      Timer(
        Duration(seconds: 3),
        () async {
          bool a = await wireguard.isConnected();
          if (a == false && vpnConnectAttempt == 0) {
            startVpn();
            vpnConnectAttempt = 1;
            update();
          }
        },
      );
      await wireguard.startVpn(
        serverAddress: initEndpoint,
        wgQuickConfig: conf,
        providerBundleIdentifier: 'com.erebrus.app.VPNExtension',
      );
      EasyLoading.dismiss();
      vpnActivate.value = true;
      getIp();
    } catch (error, stack) {
      vpnActivate.value = false;
      log("failed to start $error\n$stack");
    }
    update();
  }

  void disconnect() async {
    try {
      await wireguard.stopVpn();
      vpnActivate.value = false;
     
        await ApiController()
            .deleteVpn(uuid: registerClientModel.value.payload!.client!.uuid!);
      log("vpnActivate.value --   ${vpnActivate.value}");
      update();
    } catch (e, str) {
      debugPrint('Failed to disconnect $e\n$str');
    }
  }

  registerClient() async {
    log("initPublicKey -- $initPublicKey");
    log("presharedKey -- $presharedKey");
    // EasyLoading.show();
    try {
        EasyLoading.dismiss();
      vpnActivate.value = true;
      math.Random random = math.Random();
      sNodeid = selectedPayload.value.id.toString();
      if (box!.get("appMode") == "pro") {
        // Pro mode: use selectedPayload.id
      } else {
        // Free mode: random id
        sNodeid = countryMap![selectedNode!.value]![
                random.nextInt(countryMap![selectedNode!.value]!.length)]
            .id
            .toString();
        log("Random Selected ID: $sNodeid");
      }

      registerClientModel.value = await ApiController().registerClient(
        sNodeid,
        initPublicKey,
        initPrivateKey,
      );

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
    } catch (e) {
      EasyLoading.dismiss();
      log("registerClient() error: $e");
    }
  }
}
