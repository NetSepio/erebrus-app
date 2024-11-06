import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:wire/config/api_const.dart';
import 'package:wire/model/AllNodeModel.dart';
import 'package:wire/view/home/home_controller.dart';
import 'package:wire/view/setting/setting.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

RxBool vpnActivate = false.obs;

class VpnHomeScreen extends StatefulWidget {
  const VpnHomeScreen({super.key});

  @override
  State<VpnHomeScreen> createState() => _VpnHomeScreenState();
}

class _VpnHomeScreenState extends State<VpnHomeScreen> {
  HomeController homeController = Get.find();
  RxBool showDummyNft = false.obs;
  @override
  void initState() {
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
    Timer(
      Duration(seconds: 2),
      () {
        // showDummyNft.value = true;
      },
    );
    homeController.generateKeyPair();

    // apiCall();
    // vpnActivate ? _obtainStats() : null;
    super.initState();
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              Get.to(() => const SettingPage());
              // Get.to(() => const SettingScreen());
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
                  opacity: .1,
                  child: Image.asset(
                    'assets/background.png',
                    fit: BoxFit.fill,
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height / 1.5,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
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
                                        : homeController.countryCodes[
                                                homeController.selectedPayload
                                                    .value.ipinfocountry
                                                    .toString()] ??
                                            homeController.selectedPayload.value
                                                .ipinfocountry
                                                .toString()),
                                    const Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                      size: 15,
                                    )
                                  ],
                                )
                              : DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Select Region',
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10)),
                                  value: homeController.selectedCountry!.value,
                                  hint: const Text('Select Region'),
                                  items: homeController.countryMap!.keys
                                      .map((country) {
                                    return DropdownMenuItem<String>(
                                        value: country,
                                        child: Text(homeController
                                                .countryCodes[country] ??
                                            country));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      homeController.selectedCountry!.value =
                                          value!;

                                      homeController.selectedCity =
                                          homeController
                                              .countryMap![homeController
                                                  .selectedCountry!.value]!
                                              .first
                                              .chainName
                                              .toString();
                                      homeController.selectedPayload
                                          .value = homeController.countryMap![
                                              homeController.selectedCountry!.value]!
                                          .firstWhere((node) =>
                                              node.chainName ==
                                              homeController.selectedCity);
                                    });
                                  },
                                )
                          : const SizedBox(),
                    ),
                  ),
                  Obx(
                    () => vpnActivate.value == false &&
                            homeController.selectedCountry != null &&
                            homeController.selectedCountry!.value.isNotEmpty
                        ? DropdownButtonFormField<AllNPayload>(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Select Node',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10)),
                            value: homeController.selectedCity != null
                                ? homeController.countryMap![
                                        homeController.selectedCountry!.value]!
                                    .firstWhere((node) =>
                                        node.chainName ==
                                        homeController.selectedCity)
                                : null,
                            hint: const Text('Select Node'),
                            items: homeController
                                .countryMap![homeController.selectedCountry!.value]!
                                .map((node) {
                              return DropdownMenuItem<AllNPayload>(
                                value: node,
                                child: Text(
                                  node.id!.substring(0, 5) +
                                      " ... " +
                                      node.id!.substring(node.id!.length - 5),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12),
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
                  const SizedBox(height: 25),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (vpnActivate.value == true)
                            if (showDummyNft.value)
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xff20253A),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Text(vpnActivate.value == false
                                    ? "Location : India"
                                    : "Location : " +
                                        (homeController.countryCodes[
                                                homeController.selectedPayload
                                                    .value.ipinfocountry
                                                    .toString()] ??
                                            homeController.selectedPayload.value
                                                .ipinfocountry
                                                .toString())),
                              ),
                          SizedBox(width: 10),
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
                                        fontSize: 12,
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
                          // if (homeController.checkSub.value.status ==
                          //         "notFound" ||
                          //     homeController.checkSub.value.status ==
                          //         "expired") {
                          //   Fluttertoast.showToast(
                          //       msg: "Check Your Subscription");
                          //   return;
                          // }
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
                  const SizedBox(height: 60),
                  if (homeController.profileModel != null &&
                      homeController.profileModel!.value.payload != null)
                    nftsShow(),
                  // const SizedBox(height: 15),
                  // Obx(
                  //   () => homeController.checkSub.value.subscription != null
                  //       ? InkWell(
                  //           onTap: () {
                  //             homeController.collectionId = null;
                  //             homeController.selectedNFT.value = 0;
                  //             setState(() {});
                  //           },
                  //           child: Card(
                  //             color: homeController.collectionId == null
                  //                 ? Colors.blueGrey.shade900
                  //                 : const Color(0xff1B1A1F),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 const Padding(
                  //                   padding: EdgeInsets.only(left: 15, top: 20),
                  //                   child: Text(
                  //                     "Trial Subscription",
                  //                     style: TextStyle(
                  //                       fontSize: 22,
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 ListTile(
                  //                   title: Row(
                  //                     children: [
                  //                       Text(
                  //                         homeController.checkSub.value.status
                  //                             .toString()
                  //                             .toUpperCase(),
                  //                         style: TextStyle(
                  //                             color: homeController.checkSub
                  //                                         .value.status!
                  //                                         .toLowerCase() ==
                  //                                     "active"
                  //                                 ? Colors.green
                  //                                 : Colors.red,
                  //                             fontSize: 18),
                  //                       ),
                  //                       Text(
                  //                         homeController.checkSub.value.status!
                  //                                     .toLowerCase() ==
                  //                                 "active"
                  //                             ? " Till "
                  //                             : " ON ",
                  //                         style: const TextStyle(fontSize: 18),
                  //                       ),
                  //                       Text(
                  //                         homeController.checkSub.value
                  //                             .subscription!.endTime
                  //                             .toString()
                  //                             .split(" ")[0],
                  //                         style: const TextStyle(fontSize: 18),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   dense: true,
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 20,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         )
                  //       : const SizedBox(),
                  // ),

                  SizedBox(height: 20),
                  Obx(() => showDummyNft.value
                      ? Card(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  "assets/nft_sol.jpg",
                                  width: Get.width * .3,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Erebrus Community NFT #001"),
                                    SizedBox(height: 5),
                                    Text(
                                      "Unlock secure VPN access and become part of the Erebrus network with this exclusive NFT. Enjoy privacy, security, and the power of decentralized browsing!",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox()),
                ],
              ),
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
            "address": homeController.profileModel!.value.payload!.walletAddress
                .toString(),
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
            return Text("No Internet".toString());
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.data == null ||
              result.data!['current_token_ownerships_v2'] == null) {
            return const Text("No Data");
          }
          //result.data!['current_token_ownerships_v2'][index]['current_collection]['collection_id]
          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: result.data!['current_token_ownerships_v2'].length,
            itemBuilder: (context, index) {
              var data = result.data!['current_token_ownerships_v2'][index];

              if (homeController.collectionId != null) {
                homeController.collectionId!.value = data['current_token_data']
                    ['current_collection']["collection_id"];
              }
              var collectionName = data['current_token_data']
                  ['current_collection']["collection_name"];
              log(data.toString());
              return collectionName == "EREBRUS"
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
                                              const Icon(Icons.error),
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
