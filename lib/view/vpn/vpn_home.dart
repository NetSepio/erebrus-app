import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curve25519/flutter_curve25519.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:wire/api/api.dart';
import 'package:wire/model/AllNodeModel.dart';
import 'package:wire/model/RegisterClientModel.dart';
import 'package:wire/model/erebrus/client_model.dart';
import 'package:wire/view/home/home_controller.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

RxBool vpnActivate = false.obs;

class VpnHomeScreen extends StatefulWidget {
  const VpnHomeScreen({super.key});

  @override
  State<VpnHomeScreen> createState() => _VpnHomeScreenState();
}

class _VpnHomeScreenState extends State<VpnHomeScreen> {
  HomeController homeController = Get.find();
  Rx<AllNodeModel> allNodeModel = AllNodeModel().obs;
  Rx<RegisterClientModel> registerClientModel = RegisterClientModel().obs;
  dynamic ipData;
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

  String? collectionId;
  int selectedNFT = 0;

  ClientPayload? payload;
  getIp() async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      ipData = await ipAddress.getIpAddress();
      setState(() {});
    } on IpAddressException catch (exception) {
      print(exception.message);
    }
  }

  @override
  void initState() {
    wireguard.vpnStageSnapshot.listen((event) {
      debugPrint("status changed $event");
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('status changed: $event'),
        ));
      }
    });
    generateKeyPair();
    getAllNode();
    getIp();
    // apiCall();
    // vpnActivate ? _obtainStats() : null;
    super.initState();
  }

  getAllNode() async {
    allNodeModel.value = await ApiController().getAllNode();
    allNodeModel.value.payload!
        .removeWhere((element) => element.status == "inactive");
  }

  void generateKeyPair() {
    final random = math.Random.secure();
    List<int> seed = List<int>.generate(32, (index) => random.nextInt(256));
    final keypair = Curve25519KeyPair.fromSeed(Uint8List.fromList(seed));
    final keypair1 = Curve25519KeyPair.fromSeed(keypair.privateKey);
    print("keypair1  ${base64.encode(keypair1.privateKey)}");

    initPublicKey = base64.encode(keypair1.publicKey);
    initPrivateKey = base64.encode(keypair1.privateKey);

    List<int> seed2 = List<int>.generate(32, (index) => random.nextInt(256));
    final keypair3 = Curve25519KeyPair.fromSeed(Uint8List.fromList(seed2));
    presharedKey = base64
        .encode(Curve25519KeyPair.fromSeed(keypair3.privateKey).publicKey);
    apiCall();
    setState(() {});
  }

  apiCall() async {
    // await ApiController()
    //     .getVpnData(
    //         selectedString: selectedCountry,
    //         collectionId: collectionId ?? '',
    //         privateKey: initPublicKey)
    //     .then((ClientPayload value) {
    //   payload = value;
    //   initAddress = payload!.client!.address!.first;
    //   // initDnsServer = payload!.serverAddress!.first;
    //   initAllowedIp =
    //       "${payload!.client!.allowedIPs!.first}, ${payload!.client!.allowedIPs![1]}";
    //   initPublicKey = payload!.serverPublicKey!;
    //   initEndpoint = "${payload!.endpoint}:51820";
    //   presharedKey = payload!.client!.presharedKey!;
    //   setState(() {});
    //   startVpn();
    //   // _activateVpn(!vpnActivate);
    // });

    setState(() {});
  }

  Rx<Payload> selectedPayload = Payload().obs;

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
Endpoint = $initEndpoint''';
    log("vpn conf -- $conf");
    try {
      await wireguard.initialize(interfaceName: initName);
      await wireguard.startVpn(
        serverAddress: initEndpoint,
        wgQuickConfig: conf,
        providerBundleIdentifier: 'com.netsepio.erebrus',
      );
      vpnActivate.value = true;
    } catch (error, stack) {
      vpnActivate.value = false;
      debugPrint("failed to start $error\n$stack");
    }
    setState(() {});
  }

  void disconnect() async {
    try {
      await wireguard.stopVpn();
      vpnActivate.value = false;
      await ApiController()
          .deleteVpn(uuid: registerClientModel.value.payload!.client!.uuid!);
      log("vpnActivate.value --   ${vpnActivate.value}");
      setState(() {});
    } catch (e, str) {
      debugPrint('Failed to disconnect $e\n$str');
    }
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
          'Erebrus',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
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
                    height: MediaQuery.of(context).size.height / 1.5,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 25),
                Obx(
                  () => allNodeModel.value.payload != null
                      ? DropdownButtonFormField<Payload>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.2)),
                          ),
                          isDense: true,
                          hint: Text(selectedPayload.value.name == null
                              ? "Select region"
                              : selectedPayload.value.region.toString()),
                          onChanged: (Payload? newValue) {
                            setState(() {
                              selectedPayload.value = newValue!;
                            });
                          },
                          items: List.generate(
                              allNodeModel.value.payload!.length, (index) {
                            return DropdownMenuItem(
                              value: allNodeModel.value.payload![index],
                              child: Text(allNodeModel
                                  .value.payload![index].region
                                  .toString()),
                            );
                          }))
                      : const SizedBox(),
                ),
                // Center(
                //     child: Text(
                //   "connectionState",
                //   style: Theme.of(context).textTheme.bodyLarge,
                // )),
                const SizedBox(height: 8),
                if (ipData != null)
                  Center(
                      child: Text(
                    ipData["ip"].toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  )),
                const SizedBox(height: 100),
                // if (homeController.profileModel == null ||
                //     homeController.profileModel!.value.payload == null ||
                //     homeController.profileModel!.value.payload!.walletAddress ==
                //         null)
                //   const NoWalletFound(),
                // if (homeController.profileModel != null &&
                //     homeController.profileModel!.value.payload != null &&
                //     homeController.profileModel!.value.payload!.walletAddress !=
                //         null)
                Obx(
                  () => Center(
                    child: InkWell(
                      onTap: () {
                        // _activateVpn(!vpnActivate);
                        if (vpnActivate.value == false) {
                          registerClient();
                          // startVpn();
                          // if (payload == null) {
                          // apiCall();
                          // generateKeyPair();
                          // } else {
                          // _activateVpn(!vpnActivate);
                          // }
                        } else {
                          disconnect();
                          // _activateVpn(!vpnActivate);
                        }
                        getIp();
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
                              : const Color.fromRGBO(87, 141, 240, 1),
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
                const SizedBox(height: 20),

                // Center(
                //   child: Obx(() => Text(
                //       'Active VPN: ${stats.value.totalDownload} D -- ${stats.value.totalUpload} U')),
                // ),
                // Center(
                //     child: Text(
                //   '00.00.00',
                //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                //       fontWeight: FontWeight.w700,
                //       color: const Color.fromRGBO(37, 112, 252, 1)),
                // )),
                // const SizedBox(height: 100),

                // if (homeController.profileModel != null &&
                //     homeController.profileModel!.value.payload != null)
                //   Expanded(child: nftsShow()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  registerClient() async {
    log("initPublicKey -- $initPublicKey");
    log("presharedKey -- $presharedKey");
    registerClientModel.value = await ApiController().registerClient(
        selectedPayload.value.id.toString(), initPublicKey, presharedKey);
    RegisterPayload vpnData = registerClientModel.value.payload!;
    initAddress = vpnData.client!.address!.first;
    initAllowedIp =
        "${vpnData.client!.allowedIPs!.first}, ${vpnData.client!.allowedIPs![1]}";
    initPublicKey = vpnData.serverPublicKey!;
    initEndpoint = "${vpnData.endpoint}:${selectedPayload.value.httpPort}";
    presharedKey = vpnData.client!.presharedKey!;

    // initAddress = "10.0.0.11/32";
    // initPublicKey = "Z5Mm4YuJzCAT4NutGd7iPet6gjS2QMKIrXWSb17eqDE=";
    // initEndpoint = "35.200.116.77:9080";
    // presharedKey = "Lig2tGos63gY54M9tWzoRc3gTlA3qHqCvTVzJhORaCw=";
    setState(() {});
    startVpn();
  }

  // Widget nftsShow() {
  //   return GraphQLProvider(
  //     client: ValueNotifier<GraphQLClient>(
  //       GraphQLClient(
  //         link: HttpLink(baseUrl2),
  //         cache: GraphQLCache(),
  //       ),
  //     ),
  //     child: Query(
  //       options: QueryOptions(
  //         document: gql(r'''
  //     query getAccountCurrentTokens($address: String!, $where: [current_token_ownerships_v2_bool_exp!]!, $offset: Int, $limit: Int) {
  //     current_token_ownerships_v2(
  //       where: {owner_address: {_eq: $address}, amount: {_gt: 0}, _or: [{table_type_v1: {_eq: "0x3::token::TokenStore"}}, {table_type_v1: {_is_null: true}}], _and: $where}
  //       order_by: [{last_transaction_version: desc}, {token_data_id: desc}]
  //       offset: $offset
  //       limit: $limit
  //     ) {
  //       amount
  //       current_token_data {
  //     ...TokenDataFields
  //       }
  //       last_transaction_version
  //       property_version_v1
  //       token_properties_mutated_v1
  //       is_soulbound_v2
  //       is_fungible_v2
  //     }
  //     current_token_ownerships_v2_aggregate(
  //       where: {owner_address: {_eq: $address}, amount: {_gt: 0}}
  //     ) {
  //       aggregate {
  //     count
  //       }
  //     }
  //     }

  //     fragment TokenDataFields on current_token_datas_v2 {
  //     description
  //     token_uri
  //     token_name
  //     token_data_id
  //     current_collection {
  //       ...CollectionDataFields
  //     }
  //     token_properties
  //     token_standard
  //     cdn_asset_uris {
  //       cdn_image_uri
  //     }
  //     }

  //     fragment CollectionDataFields on current_collections_v2 {
  //     uri
  //     max_supply
  //     description
  //     collection_name
  //     collection_id
  //     creator_address
  //     cdn_asset_uris {
  //       cdn_image_uri
  //     }
  //     }
  //     '''),
  //         variables: {
  //           "address": homeController.profileModel!.value.payload!.walletAddress
  //               .toString(),
  //           // "0xc143aba11d86c6a0d5959eaec1ad18652693768d92daab18f323fd7de1dc9829",
  //           "limit": 12,
  //           "offset": 0,
  //           "where": const [],
  //         },
  //         operationName: "getAccountCurrentTokens",
  //       ),
  //       builder: (QueryResult result, {refetch, fetchMore}) {
  //         if (result.hasException) {
  //           log("Exception --  ${result.exception}");
  //           return Text(result.exception.toString());
  //         }

  //         if (result.isLoading) {
  //           return const Center(child: CircularProgressIndicator());
  //         }

  //         if (result.data == null ||
  //             result.data!['current_token_ownerships_v2'] == null) {
  //           return const Text("No Data");
  //         }
  //         //result.data!['current_token_ownerships_v2'][index]['current_collection]['collection_id]
  //         return ListView.builder(
  //           shrinkWrap: true,
  //           // padding: const EdgeInsets.all(20),
  //           itemCount: result.data!['current_token_ownerships_v2'].length,
  //           itemBuilder: (context, index) {
  //             var data = result.data!['current_token_ownerships_v2'][index];

  //             collectionId ??= data['current_token_data']['current_collection']
  //                 ["collection_id"];
  //             return Column(
  //               children: [
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Wrap(
  //                       crossAxisAlignment: WrapCrossAlignment.center,
  //                       children: [
  //                         const CircleAvatar(
  //                           radius: 15,
  //                           backgroundColor: Colors.white,

  //                           // backgroundImage: ExactAssetImage(
  //                           //   freeServers[index].flag!,
  //                           // ),
  //                         ),
  //                         if (data['current_token_data']["token_uri"] != null)
  //                           CachedNetworkImage(
  //                             imageUrl: data['current_token_data']["token_uri"]
  //                                 .toString()
  //                                 .replaceFirst('ipfs://',
  //                                     r'https://nftstorage.link/ipfs/'),
  //                             height: 50,
  //                             width: 50,
  //                             placeholder: (context, url) =>
  //                                 const CircularProgressIndicator(),
  //                             errorWidget: (context, url, error) =>
  //                                 const Icon(Icons.error),
  //                           ),
  //                         // Image.network(
  //                         //   (data['current_token_data']["token_uri"]
  //                         //       .toString()
  //                         //       .replaceFirst('ipfs://',
  //                         //           r'https://nftstorage.link/ipfs/').replaceAll('.json', '')),
  //                         //   height: 50,
  //                         //   width: 50,
  //                         // ),
  //                         const SizedBox(
  //                           width: 15,
  //                         ),
  //                         Text(
  //                           data["current_token_data"]["description"]
  //                               .toString(),
  //                           style: Theme.of(context).textTheme.bodyLarge,
  //                         ),
  //                       ],
  //                     ),

  //                     InkWell(
  //                       onTap: () {
  //                         selectedNFT = index;

  //                         collectionId = data['current_token_data']
  //                             ['current_collection']["collection_id"];
  //                         setState(() {});
  //                       },
  //                       child: selectedNFT == index
  //                           ? const Icon(
  //                               Icons.check_circle,
  //                               size: 30,
  //                               color: Color.fromRGBO(37, 112, 252, 1),
  //                             )
  //                           : const Icon(
  //                               Icons.circle_outlined,
  //                               size: 30,
  //                               color: Color.fromRGBO(37, 112, 252, 1),
  //                             ),
  //                     )
  //                     // RoundCheckBox(
  //                     //   size: 24,
  //                     //   checkedWidget: const Icon(
  //                     //     Icons.check,
  //                     //     size: 18,
  //                     //     color: Colors.white,
  //                     //   ),
  //                     //   borderColor:
  //                     //       const Color.fromRGBO(37, 112, 252, 1),
  //                     //   checkedColor:
  //                     //       const Color.fromRGBO(37, 112, 252, 1),
  //                     //   isChecked: false,
  //                     //   onTap: (x) {},
  //                     // ),
  //                   ],
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
}
