import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curve25519/flutter_curve25519.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:wire/api/api.dart';
import 'package:wire/config/api_const.dart';
import 'package:wire/model/erebrus/client_model.dart';
import 'package:wire/view/home/home_controller.dart';
import 'package:wire/view/profile/profile_page.dart';
import 'package:wire/view/setting/setting.dart';
import 'package:wireguard_vpn/wireguard_vpn.dart';

class VpnScreenUI extends StatefulWidget {
  const VpnScreenUI({super.key});

  @override
  State<VpnScreenUI> createState() => _VpnScreenUIState();
}

class _VpnScreenUIState extends State<VpnScreenUI> {
  HomeController homeController = Get.find();
  dynamic ipData;

  final _wireguardFlutterPlugin = WireguardVpn();
  bool vpnActivate = false;
  Rx<Stats> stats = Stats(totalDownload: 0, totalUpload: 0).obs;

  String initName = 'MyWireguardVPN';
  String initAddress = "10.0.0.5/32";
  String initPort = "51820";
  String initDnsServer = '1.1.1.1'; //"172.30.0.2";
  String initPrivateKey = "+KxkabF/Zz46PnHWwtDpzTnhMRS6B5crXrIpcEQwyFo=";
  String initAllowedIp = "0.0.0.0/0, ::/0";
  String initPublicKey = "xNtJC/MiZeasw8pMgxkrmZ8HyAdJqa/wrV3/nTPYfkY=";
  String initEndpoint = "endereum-sotreus.us01.sotreus.com:43913";
  String presharedKey = '9auFuIxN4+hlAjQ/oLSNgpZsGD3XfktmWwGngTXIlsA=';
  String? collectionId;
  int selectedNFT = 0;

  ClientPayload? payload;
  getIp() async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      ipData = await ipAddress.getIpAddress();
    } on IpAddressException catch (exception) {
      print(exception.message);
    }
  }

  @override
  void initState() {
    getIp();
    // apiCall();
    vpnActivate ? _obtainStats() : null;
    super.initState();
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
    apiCall();
    setState(() {});
  }

  apiCall() async {
    await ApiController()
        .getVpnData(
            selectedString: selectedCountry,
            collectionId: collectionId ?? '',
            privateKey: initPublicKey)
        .then((ClientPayload value) {
      payload = value;
      initAddress = payload!.client!.address!.first;
      // initDnsServer = payload!.serverAddress!.first;
      initAllowedIp =
          "${payload!.client!.allowedIPs!.first}, ${payload!.client!.allowedIPs![1]}";
      initPublicKey = payload!.serverPublicKey!;
      initEndpoint = '${payload!.endpoint!}:51820';
      presharedKey = payload!.client!.presharedKey!;
      _activateVpn(!vpnActivate);
    });

    setState(() {});
  }

  // void generateKeyPair() {
  //   List<int> seed = generateRandomBytes(32);

  //   // Generate key pair
  //   final keypair = Curve25519KeyPair.fromSeed(Uint8List.fromList(seed));

  //   final keypair1 = Curve25519KeyPair.fromSeed(keypair.privateKey);
  //   print("keypair1  ${keypair1.privateKey}");
  //   final keypair2 = Curve25519KeyPair.fromSeed(keypair.privateKey);
  //   print("keypair2 ${keypair2.publicKey}");
  // }

  // List<int> generateRandomBytes(int length) {
  //   final random = Random.secure();
  //   List<int> bytes =
  //       List<int>.generate(length, (index) => random.nextInt(256));
  //   return bytes;
  // }

  //us,sg,ca,eu,jp

  List<Map<String, String>> countries = [
    {'name': 'United States', 'code': 'us'},
    {'name': 'Singapore', 'code': 'sg'},
    {'name': 'Canada', 'code': 'ca'},
    {'name': 'European', 'code': 'eu'},
    // {'name': 'Japan', 'code': 'jp'},
  ];
  String selectedCountry = 'us';

  void _obtainStats() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final results = await _wireguardFlutterPlugin.tunnelGetStats(initName);
      // setState(() {
      stats.value = results ?? Stats(totalDownload: 0, totalUpload: 0);
      // });
    });
  }

  void _activateVpn(bool value) async {
    try {
      log({
        "name": initName,
        "address": initAddress,
        "dnsServer": initDnsServer,
        "listenPort": initPort,
        "peerAllowedIp": initAllowedIp,
        "peerEndpoint": initEndpoint,
        "peerPublicKey": initPublicKey,
        "privateKey": initPrivateKey,
        "peerPresharedKey": presharedKey
      }.toString());
      final results =
          await _wireguardFlutterPlugin.changeStateParams(SetStateParams(
        state: !vpnActivate,
        tunnel: Tunnel(
            name: initName,
            address: initAddress,
            dnsServer: initDnsServer,
            listenPort: initPort,
            peerAllowedIp: initAllowedIp,
            peerEndpoint: initEndpoint,
            peerPublicKey: initPublicKey,
            privateKey: initPrivateKey,
            peerPresharedKey: presharedKey),
      ));
      print(results.toString());
      if (vpnActivate == true) {
        ApiController().deleteVpn(
            uuid: payload!.client!.uUID!, selectedString: selectedCountry);
      }
      setState(() {
        vpnActivate = results ?? false;
        vpnActivate ? _obtainStats() : null;
      });
    } catch (e) {
      print(e.toString());
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
        actions: [
          InkWell(
              onTap: () => Get.to(() => const ProfilePage()),
              child: const Icon(Icons.person, color: Colors.black)),
          const SizedBox(width: 20),
          InkWell(
              onTap: () {
                Get.to(() => const SettingsPage());
              },
              child: const Icon(
                Icons.settings,
                color: Colors.black,
              )),
          const SizedBox(width: 20),
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
                    height: MediaQuery.of(context).size.height / 1.5,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 25),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 0.2)),
                  ),
                  isDense: true,
                  value: selectedCountry,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCountry = newValue!;
                    });
                  },
                  items: countries.map<DropdownMenuItem<String>>(
                      (Map<String, String> country) {
                    return DropdownMenuItem<String>(
                      value: country['code'],
                      child: Text(country['name']!),
                    );
                  }).toList(),
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
                const Spacer(),
                Center(
                  child: InkWell(
                    onTap: () {
                      // _activateVpn(!vpnActivate);
                      if (vpnActivate == false) {
                        // if (payload == null) {
                        // apiCall();
                        generateKeyPair();
                        // } else {
                        //   _activateVpn(!vpnActivate);
                        // }
                      } else {
                        _activateVpn(!vpnActivate);
                      }
                    },
                    borderRadius: BorderRadius.circular(90),
                    child: AvatarGlow(
                      glowColor: vpnActivate == true
                          ? Colors.green
                          : const Color.fromRGBO(37, 112, 252, 1),
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      animate: vpnActivate == true ? true : false,
                      glowShape: BoxShape.circle,
                      child: Material(
                        elevation: 0,
                        shape: const CircleBorder(),
                        color: vpnActivate == true
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
                                vpnActivate == true ? "Connected" : 'Connect',
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
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_upward, size: 15),
                        Text('${stats.value.totalUpload}'),
                        const Icon(Icons.arrow_downward, size: 15),
                        Text('${stats.value.totalDownload}'),
                      ],
                    )),
                const SizedBox(height: 20),
                const Spacer(),
                if (homeController.profileModel != null &&
                    homeController.profileModel!.value.payload != null)
                  SizedBox(width: Get.width, child: nftsShow()),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      //   child: TextButton.icon(
      //     style: TextButton.styleFrom(
      //       shape:
      //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //       padding: EdgeInsets.symmetric(
      //           vertical: 15,
      //           horizontal: MediaQuery.of(context).size.width / 4.5),
      //       backgroundColor: const Color.fromRGBO(37, 112, 252, 1),
      //     ),
      //     onPressed: () {},
      //     icon: const Icon(
      //       Icons.star,
      //       color: Colors.white,
      //     ),
      //     label: Text(
      //       'Network Details',
      //       style: Theme.of(context)
      //           .textTheme
      //           .labelLarge!
      //           .copyWith(color: Colors.white),
      //     ),
      //   ),
      // ),
    );
  }

  Widget nftsShow() {
    return Obx(
      () => GraphQLProvider(
        client: ValueNotifier<GraphQLClient>(
          GraphQLClient(
            link: HttpLink(baseUrl),
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
              "address": homeController
                  .profileModel!.value.payload!.walletAddress
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
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (result.data == null ||
                result.data!['current_token_ownerships_v2'] == null) {
              return const Center(child: Text("No Data"));
            }
            //result.data!['current_token_ownerships_v2'][index]['current_collection]['collection_id]
            return ListView.builder(
              shrinkWrap: true,
              // padding: const EdgeInsets.all(20),
              itemCount: result.data!['current_token_ownerships_v2'].length,
              itemBuilder: (context, index) {
                var data = result.data!['current_token_ownerships_v2'][index];

                collectionId ??= data['current_token_data']
                    ['current_collection']["collection_id"];
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,

                              // backgroundImage: ExactAssetImage(
                              //   freeServers[index].flag!,
                              // ),
                            ),
                            if (data['current_token_data']["token_uri"] != null)
                              CachedNetworkImage(
                                imageUrl: data['current_token_data']
                                        ["token_uri"]
                                    .toString()
                                    .replaceFirst('ipfs://',
                                        r'https://nftstorage.link/ipfs/'),
                                height: 50,
                                width: 50,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            // Image.network(
                            //   (data['current_token_data']["token_uri"]
                            //       .toString()
                            //       .replaceFirst('ipfs://',
                            //           r'https://nftstorage.link/ipfs/').replaceAll('.json', '')),
                            //   height: 50,
                            //   width: 50,
                            // ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              data["current_token_data"]["description"]
                                  .toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),

                        InkWell(
                          onTap: () {
                            selectedNFT = index;

                            collectionId = data['current_token_data']
                                ['current_collection']["collection_id"];
                            setState(() {});
                          },
                          child: selectedNFT == index
                              ? const Icon(
                                  Icons.check_circle,
                                  size: 30,
                                  color: Color.fromRGBO(37, 112, 252, 1),
                                )
                              : const Icon(
                                  Icons.circle_outlined,
                                  size: 30,
                                  color: Color.fromRGBO(37, 112, 252, 1),
                                ),
                        )
                        // RoundCheckBox(
                        //   size: 24,
                        //   checkedWidget: const Icon(
                        //     Icons.check,
                        //     size: 18,
                        //     color: Colors.white,
                        //   ),
                        //   borderColor:
                        //       const Color.fromRGBO(37, 112, 252, 1),
                        //   checkedColor:
                        //       const Color.fromRGBO(37, 112, 252, 1),
                        //   isChecked: false,
                        //   onTap: (x) {},
                        // ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ServerItemWidget extends StatelessWidget {
  const ServerItemWidget(
      {Key? key,
      required this.label,
      required this.icon,
      required this.flagAsset,
      required this.onTap,
      this.isFaded = false})
      : super(key: key);

  final String label;
  final IconData icon;
  final String flagAsset;
  final VoidCallback onTap;
  final isFaded;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    backgroundImage: ExactAssetImage(
                      flagAsset,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              IconButton(
                icon: Icon(icon),
                onPressed: onTap,
                iconSize: 18,
                color:
                    isFaded ? Colors.grey : Theme.of(context).iconTheme.color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
