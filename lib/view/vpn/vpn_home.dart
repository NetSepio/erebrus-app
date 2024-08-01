import 'dart:developer';

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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Disconnected from VPN'),
            ));
            break;
          default:
        }
      }
    });
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
        title: Text(
          'EREBRUS',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
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
                    height: 100,
                    width: Get.width,
                    child: Obx(
                      () => homeController.allNodeModel.value.payload != null
                          ? vpnActivate.value == true
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(homeController
                                                .selectedPayload.value.name ==
                                            null
                                        ? "Select region"
                                        : homeController
                                            .selectedPayload.value.ipinfocity
                                            .toString()),
                                    const Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                      size: 15,
                                    )
                                  ],
                                )
                              : DropdownButtonFormField<AllNPayload>(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 0.2)),
                                  ),
                                  isDense: true,
                                  hint: Text(homeController
                                              .selectedPayload.value.name ==
                                          null
                                      ? "Select region"
                                      : homeController
                                          .selectedPayload.value.ipinfocity
                                          .toString()),
                                  onChanged: (AllNPayload? newValue) {
                                    setState(() {
                                      homeController.selectedPayload.value =
                                          newValue!;
                                    });
                                  },
                                  items: List.generate(
                                      homeController.allNodeModel.value.payload!
                                          .length, (index) {
                                    if (homeController
                                            .selectedPayload.value.region ==
                                        null) {
                                      homeController.selectedPayload.value =
                                          homeController.allNodeModel.value
                                              .payload![index];
                                    }
                                    return DropdownMenuItem(
                                      value: homeController
                                          .allNodeModel.value.payload![index],
                                      child: Text(homeController.allNodeModel
                                          .value.payload![index].ipinfocity
                                          .toString()),
                                    );
                                  }))
                          : const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => homeController.ipData.value.isNotEmpty
                        ? Center(
                            child: Text(
                            "Current IP: ${homeController.ipData.value["ip"]}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600),
                          ))
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 100),
                  Obx(
                    () => Center(
                      child: InkWell(
                        onTap: () {
                          // _activateVpn(!vpnActivate);
                          if (vpnActivate.value == false) {
                            if (homeController.collectionId != null &&
                                homeController.selectedNFT.value != 0) {
                              homeController.apiCall();
                            } else {
                              homeController.registerClient();
                            }
                            // startVpn();
                            // if (payload == null) {
                            // apiCall();
                            // generateKeyPair();
                            // } else {
                            // _activateVpn(!vpnActivate);
                            // }
                          } else {
                            homeController.generateKeyPair();
                            homeController.disconnect();
                            // _activateVpn(!vpnActivate);
                          }
                          homeController.getIp();
                        },
                        borderRadius: BorderRadius.circular(90),
                        child: AvatarGlow(
                          glowColor:
                              //  vpnActivate.value == true
                              //     ? Colors.green
                              //     :
                              const Color.fromRGBO(37, 112, 252, 1),
                          duration: const Duration(milliseconds: 2000),
                          repeat: true,
                          animate: vpnActivate.value == true ? true : false,
                          glowShape: BoxShape.circle,
                          child: Material(
                            elevation: 0,
                            shape: const CircleBorder(),
                            color:
                                //  vpnActivate.value == true
                                //     ? Colors.green
                                //     :
                                const Color.fromRGBO(87, 141, 240, 1),
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
                  const SizedBox(height: 15),
                  Obx(
                    () => homeController.checkSub.value.subscription != null
                        ? InkWell(
                            onTap: () {
                              homeController.collectionId = null;
                              homeController.selectedNFT.value = 0;
                              setState(() {});
                            },
                            child: Card(
                              color: homeController.collectionId == null
                                  ? Colors.blueGrey.shade900
                                  : const Color(0xff1B1A1F),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15, top: 20),
                                    child: Text(
                                      "Trial Subscription",
                                      style: TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Row(
                                      children: [
                                        Text(
                                          homeController.checkSub.value.status
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              color: homeController.checkSub
                                                          .value.status!
                                                          .toLowerCase() ==
                                                      "active"
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          homeController.checkSub.value.status!
                                                      .toLowerCase() ==
                                                  "active"
                                              ? " Till "
                                              : " ON ",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          homeController.checkSub.value
                                              .subscription!.endTime
                                              .toString()
                                              .split(" ")[0],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    dense: true,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
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
                                          // Text(
                                          //   data["current_token_data"]["description"]
                                          //       .toString(),
                                          //   style:
                                          //       Theme.of(context).textTheme.bodyLarge,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     selectedNFT = index;

                                  //     collectionId = data['current_token_data']
                                  //         ['current_collection']["collection_id"];
                                  //     setState(() {});
                                  //   },
                                  //   child: selectedNFT == index
                                  //       ? const Icon(
                                  //           Icons.check_circle,
                                  //           size: 30,
                                  //           color:
                                  //               Color.fromRGBO(37, 112, 252, 1),
                                  //         )
                                  //       : const Icon(
                                  //           Icons.circle_outlined,
                                  //           size: 30,
                                  //           color:
                                  //               Color.fromRGBO(37, 112, 252, 1),
                                  //         ),
                                  // )
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
