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

RxBool vpnActivate = false.obs;

class VpnHomeScreen extends StatefulWidget {
  const VpnHomeScreen({super.key});

  @override
  State<VpnHomeScreen> createState() => _VpnHomeScreenState();
}

ProfileController profileController = Get.find();

class _VpnHomeScreenState extends State<VpnHomeScreen> {
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
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Successfully Connected to VPN'),
            ));
            break;
          case VpnStage.disconnected:
            ScaffoldMessenger.of(context).clearSnackBars();
            if (Platform.isAndroid)
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Disconnected from VPN'),
              ));
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
    // log("appKitModal -->" + appKitModal!.isConnected.toString());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Obx(
          () => vpnActivate.value == true
              ? Text(
                  '⦿ Connected',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.green),
                )
              : Text(
                  'EREBRUS',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => const SettingPage())!.whenComplete(
                () {
                  setState(() {});
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
              top: 50,
              child: Opacity(
                opacity: .3,
                child: Image.asset(
                  "assets/glob.jpg",
                  // 'assets/background.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  // color: Colors.white,
                  height: Get.height,
                  width: Get.width,
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 25),
                SizedBox(
                  height: 70,
                  width: Get.width,
                  child: Obx(
                    () => homeController.allNodeModel.value.payload != null &&
                            homeController.countryMap != null
                        ? vpnActivate.value == true
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(homeController
                                              .selectedPayload.value.name ==
                                          null
                                      ? "Select Region"
                                      : countryCodeToEmoji(homeController
                                              .selectedPayload
                                              .value
                                              .ipinfocountry
                                              .toString()) +
                                          " " +
                                          (homeController.countryCodes[
                                                  homeController.selectedPayload
                                                      .value.ipinfocountry
                                                      .toString()] ??
                                              homeController.selectedPayload
                                                  .value.ipinfocountry
                                                  .toString())),
                                  const Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                    size: 15,
                                  )
                                ],
                              )
                            : DropdownButtonFormField2(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Select Region',
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10)),
                                isDense: false,
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: Get.height * .6,
                                ),
                                value: homeController.selectedNode!.value,
                                hint: const Text('Select Region'),
                                items: homeController.countryMap!.keys
                                    .map((country) {
                                  return DropdownMenuItem<String>(
                                      value: country,
                                      child: Text(countryCodeToEmoji(country) +
                                          ' ' +
                                          (homeController
                                                  .countryCodes[country] ??
                                              country)));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    homeController.selectedNode!.value = value!;

                                    homeController.selectedCity = homeController
                                        .countryMap![
                                            homeController.selectedNode!.value]!
                                        .first
                                        .chainName
                                        .toString();
                                    homeController.selectedPayload
                                        .value = homeController.countryMap![
                                            homeController.selectedNode!.value]!
                                        .firstWhere((node) =>
                                            node.chainName ==
                                            homeController.selectedCity);
                                  });
                                },
                              )
                        : const SizedBox(),
                  ),
                ),
                if (box!.get("appMode") == "pro")
                  Obx(
                    () => vpnActivate.value == false &&
                            homeController.selectedNode != null &&
                            homeController.selectedNode!.value.isNotEmpty
                        ? DropdownButtonFormField2<AllNPayload>(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Select Node',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10)),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: Get.height * .6,
                            ),
                            value: homeController.selectedCity != null
                                ? homeController.countryMap![
                                        homeController.selectedNode!.value]!
                                    .firstWhere((node) =>
                                        node.chainName ==
                                        homeController.selectedCity)
                                : null,
                            hint: const Text('Select Node'),
                            items: homeController.countryMap![
                                    homeController.selectedNode!.value]!
                                .map((node) {
                              return DropdownMenuItem<AllNPayload>(
                                value: node,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      node.id!.substring(0, 5) +
                                          " ... " +
                                          node.id!
                                              .substring(node.id!.length - 5) +
                                          "    ",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "${node.chainName}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (AllNPayload? value) {
                              setState(() {
                                homeController.selectedCity = value!.chainName;
                                homeController.selectedPayload.value = value;
                                log(homeController
                                    .selectedPayload.value.ipinfocountry
                                    .toString());
                              });
                            },
                          )
                        : const SizedBox(),
                  ),

                Obx(
                  () => (vpnActivate.value == true)
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RichText(
                            text: TextSpan(
                              text: "You are now connected to ",
                              style: TextStyle(
                                  wordSpacing: 1.5,
                                  color: Colors.grey.shade300),
                              children: [
                                TextSpan(
                                  text:
                                      "${countryCodeToEmoji(homeController.selectedPayload.value.ipinfocountry.toString())} ${homeController.countryCodes[homeController.selectedPayload.value.ipinfocountry.toString().toUpperCase()] ?? homeController.selectedPayload.value.ipinfocountry.toString().toUpperCase()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                TextSpan(
                                  text:
                                      " with Node ID: ${homeController.sNodeid} running on ",
                                ),
                                TextSpan(
                                  text:
                                      "${homeController.countryMap![homeController.selectedNode!.value]!.firstWhere((node) => node.chainName == homeController.selectedCity).chainName!.toUpperCase()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                TextSpan(text: " Blockchain"),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(height: 25),
                ),

                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (homeController.ipData.value.isNotEmpty)
                          Expanded(
                            child: Container(
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xff20253A),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Text(
                                "Current IP : " +
                                    (homeController.selectedPayload.value
                                                    .ipinfoip !=
                                                null &&
                                            vpnActivate.value == true
                                        ? "${homeController.selectedPayload.value.ipinfoip}"
                                        : "${homeController.ipData.value["ip"]}"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          )
                      ],
                    )),

                SizedBox(
                  height: 10,
                ),
                // if (vpnActivate.value == true)

                const SizedBox(height: 80),
                Obx(
                  () => Center(
                    child: InkWell(
                      onTap: () {
                        if (homeController.checkSub.value.status == "notFound"
                            //     ||
                            // homeController.checkSub.value.status ==
                            //     "expired"
                            ) {
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
                        } else {
                          homeController.generateKeyPair();
                          homeController.disconnect();
                        }
                        homeController.getIp();
                      },
                      borderRadius: BorderRadius.circular(90),
                      child: AvatarGlow(
                        glowColor: vpnActivate.value == true
                            ? Colors.green
                            : const Color.fromRGBO(37, 112, 252, 1),
                        duration: const Duration(milliseconds: 2000),
                        repeat: true,
                        animate: vpnActivate.value == true ? true : false,
                        glowShape: BoxShape.circle,
                        child: Material(
                          elevation: 0,
                          shape: const CircleBorder(),
                          color: vpnActivate.value == true
                              ? Colors.green
                              : const Color(0xff0162FF),
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.power_settings_new,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  vpnActivate.value == true
                                      ? "Connected"
                                      : 'Connect',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget nftsShow() {
    return GraphQLProvider(
      client: ValueNotifier<GraphQLClient>(
        GraphQLClient(
          link: HttpLink(baseUrl2),
          cache: GraphQLCache(),
        ),
      ),
      child: Query(
        options: QueryOptions(
          document: gql(r'''
      query getAccountCurrentTokens($address: String!, $where: [current_token_ownerships_v2_bool_exp!]!, $offset: Int, $limit: Int) {
      current_token_ownerships_v2(
        where: {owner_address: {_eq: $address}, amount: {_gt: 0}, _or: [{table_type_v1: {_eq: "0x3::token::TokenStore"}}, {table_type_v1: {_is_null: true}}], _and: $where}
        order_by: [{last_transaction_version: desc}, {token_data_id: desc}]
        offset: $offset
        limit: $limit
      ) {
        amount
        current_token_data {
      ...TokenDataFields
        }
        last_transaction_version
        property_version_v1
        token_properties_mutated_v1
        is_soulbound_v2
        is_fungible_v2
      }
      current_token_ownerships_v2_aggregate(
        where: {owner_address: {_eq: $address}, amount: {_gt: 0}}
      ) {
        aggregate {
      count
        }
      }
      }
    
      fragment TokenDataFields on current_token_datas_v2 {
      description
      token_uri
      token_name
      token_data_id
      current_collection {
        ...CollectionDataFields
      }
      token_properties
      token_standard
      cdn_asset_uris {
        cdn_image_uri
      }
      }
    
      fragment CollectionDataFields on current_collections_v2 {
      uri
      max_supply
      description
      collection_name
      collection_id
      creator_address
      cdn_asset_uris {
        cdn_image_uri
      }
      }
      '''),
          variables: {
            "address": box!.get("selectedWalletAddress"),
            // "0xc143aba11d86c6a0d5959eaec1ad18652693768d92daab18f323fd7de1dc9829",
            "limit": 12,
            "offset": 0,
            "where": const [],
          },
          operationName: "getAccountCurrentTokens",
        ),
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.hasException) {
            log("Exception --  ${result.exception}");
            return Text("".toString());
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.data == null ||
              result.data!['current_token_ownerships_v2'] == null) {
            return const Text("");
          }
          //result.data!['current_token_ownerships_v2'][index]['current_collection]['collection_id]
          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            itemCount: result.data!['current_token_ownerships_v2'].length,
            itemBuilder: (context, index) {
              var data = result.data!['current_token_ownerships_v2'][index];

              if (homeController.collectionId != null) {
                homeController.collectionId!.value = data['current_token_data']
                    ['current_collection']["collection_id"];
              }
              var collectionName = data['current_token_data']
                  ['current_collection']["collection_name"];
              log("NFF))) " + data.toString());
              return collectionName.toString().contains("NETSEPIO") ||
                      collectionName.toString().contains("EREBRUS")
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            homeController.selectedNFT.value = index + 1;

                            homeController.collectionId =
                                data['current_token_data']['current_collection']
                                        ["collection_id"]
                                    .toString()
                                    .obs;

                            setState(() {});
                          },
                          child: Card(
                            color: homeController.collectionId != null &&
                                    homeController.selectedNFT.value != 0
                                ? Colors.blueGrey.shade900
                                : const Color(0xff1B1A1F),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      if (data['current_token_data']
                                              ["token_uri"] !=
                                          null)
                                        CachedNetworkImage(
                                          imageUrl: data['current_token_data']
                                                      ["cdn_asset_uris"]
                                                  ["cdn_image_uri"]
                                              .toString(),
                                          height: 120,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                                "assets/erebrus_mobile_app_icon.png"),
                                          ),
                                        ),
                                      const SizedBox(width: 15),
                                      Column(
                                        children: [
                                          Text(
                                            "${data["current_token_data"]["token_name"]}",
                                            style: const TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            },
          );
        },
      ),
    );
  }
}
