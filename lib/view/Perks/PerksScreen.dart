import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PerksScreen extends StatefulWidget {
  const PerksScreen({super.key});

  @override
  State<PerksScreen> createState() => _PerksScreenState();
}

class _PerksScreenState extends State<PerksScreen> {
  // CheckSubscriptionModel? checkSub;
  RxBool isLoading = true.obs;
  RxInt isSelectedIndex = 0.obs;
  var tokenAddress = [];
  List nftSubscriptionMintAddress = [];
  // [
  //   "2PxZ4tUKtT622TvbKWQ2bUtacaHATtQrmCkYcFuzxy5S",
  //   "FgS1q7Q4m1PF6v4PKYsQq6MfLZMxhucDkJdWwRqm7xwQ",
  //   "AwwNvkZisYzgquqiE2RUieiHtgJt5LsGVHUqzTDxJnSx",
  //   "CCW7TUdn5XZmcPVc2fNDrELZmpReefLPSk31cZ935nFx",
  //   "3rh6GDULkk4FfsnHV9RiEGhHGoi58CRDLXM2SmqACfZm"
  // ];
  @override
  void initState() {
    super.initState();
    getNfts();
    // checkSubscription();
  }

  getAllNfts() async {
    try {
      var res =
          await Dio().get("gateway.erebrus.io/api/v1.0/subscription/nft/all");
      nftDta = res.data;
      tokenAddress = nftDta["nfts"];
      setState(() {});
      log("Nft data -- ${nftDta}");
    } catch (e) {}
    try {
      var res = await Dio()
          .get("http://gateway.erebrus.io/api/v1.0/subscription/mint/all");
      for (var i = 0; i < res.data.length; i++) {
        nftSubscriptionMintAddress.add(res.data[i]["mint_address"].toString());
      }
      setState(() {});
      // log("Nft Mint add -- ${nftSubscriptionMintAddress}");
    } catch (e) {}
    setState(() {
      isLoading.value = false;
    });
  }

  var nftDta;
  getNfts() async {
    try {
      if (box!.containsKey("ApiWallet") && box!.get("ApiWallet") != null) {
        var res = await Dio().get(
          dotenv.get("SOLANA_NFT_API") + "/${box!.get("ApiWallet")}/tokens",
          // dotenv.get("SOLANA_NFT_API") +
          //     "/8bDudaBScd3qSiuE2VujZ5Pr29ruaLg25MhgPMRCjv5d/tokens",
        );
        nftDta = res.data;
        log("Nft data -- ${nftDta}");
        setState(() {});
      } else {
        var res = await Dio().get(dotenv.get("SOLANA_NFT_API") +
            "/${box!.get("selectedWalletAddress")}/tokens");
        nftDta = res.data;
        setState(() {});
      }
    } catch (e) {}
    getAllNfts();
  }

  getTokens(mintAddress) async {
    var tokesData;
    var res = await Dio().post(
        "https://mainnet.helius-rpc.com/?api-key=c82bd316-8563-4569-a6ad-29c9dd2b6d7f",
        data: {
          "jsonrpc": "2.0",
          "id": 1,
          "method": "getTokenAccountsByOwner",
          "params": [
            // "8bDudaBScd3qSiuE2VujZ5Pr29ruaLg25MhgPMRCjv5d",
            "${box!.get("ApiWallet") ?? box!.get("selectedWalletAddress") ?? ""}",
            {"mint": mintAddress},
            {"encoding": "jsonParsed"}
          ]
        });
    tokesData = res.data;
    log("tokesData data --  ${tokesData}");
    return tokesData;
  }

  // checkSubscription() async {
  //   EasyLoading.show();
  //   try {
  //     checkSub = await ApiController().checkSubscription();
  //     await getNfts();
  //     isLoading.value = false;
  //     setState(() {});
  //     EasyLoading.dismiss();
  //   } catch (e) {
  //     isLoading.value = false;
  //     EasyLoading.dismiss();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Perks'.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(
          () => isLoading.value
              ? const Center(
                  // child: CircularProgressIndicator(),
                  )
              : Column(
                  children: [
                    SizedBox(width: Get.width),
                    // if (checkSub == null ||
                    //     checkSub!.subscription == null &&
                    //         isLoading.value == false)
                    if (nftDta == null || nftDta.length == 0)
                      SizedBox(
                          height: Get.height - 200,
                          child: Center(child: Text("No NFT's Found"))),
                    if (nftDta != null)
                      if ((box!.get("selectedWalletName") == "Solana") ||
                          (profileController.profileModel.value.payload !=
                                  null &&
                              profileController
                                      .profileModel.value.payload!.chainName
                                      .toString()
                                      .toLowerCase() ==
                                  "solana"))
                        Card(
                          child: ListView.separated(
                            itemCount: nftDta.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var data = nftDta[index];
                              return nftSubscriptionMintAddress
                                      .contains(data["mintAddress"])
                                  ? Obx(
                                      () => ListTile(
                                        onTap: () {
                                          isSelectedIndex.value = index;
                                        },
                                        trailing: isSelectedIndex.value == index
                                            ? Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : null,
                                        leading: Image.network(
                                          data["image"].toString(),
                                          fit: BoxFit.cover,
                                          width: 80,
                                        ),
                                        title: Text(data["name".toString()]),
                                      ),
                                    )
                                  : SizedBox();
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return nftSubscriptionMintAddress
                                      .contains(nftDta[index]["mintAddress"])
                                  ? Divider(indent: 100, height: 20)
                                  : SizedBox();
                            },
                          ),
                        ),

                    if ((nftDta != null &&
                            box!.get("selectedWalletName") == "Solana") ||
                        (profileController.profileModel.value.payload != null &&
                            profileController
                                    .profileModel.value.payload!.chainName ==
                                "solana"))
                      SizedBox(height: 10),
                    if (box!.get("selectedWalletName") == "Solana" ||
                        (profileController.profileModel.value.payload != null &&
                            profileController
                                    .profileModel.value.payload!.chainName
                                    .toString()
                                    .toLowerCase() ==
                                "solana"))
                      InkWell(
                        child: Card(
                          child: ListView.builder(
                              itemCount: tokenAddress.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return FutureBuilder(
                                    future: getTokens(
                                        tokenAddress[index]["mint_address"]),
                                    builder: (context, _) {
                                      if (_.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox();
                                      }
                                      if (_.hasError || _.data == null) {
                                        return SizedBox();
                                      }
                                      dynamic tokenData = _.data;
                                      // log("message---${index} ${tokenData}");

                                      if (tokenData == null ||
                                          tokenData["result"] == null) {
                                        return SizedBox();
                                      }
                                      if (tokenData == null ||
                                          tokenData["result"] == null ||
                                          tokenData["result"]["value"]
                                              .isEmpty) {
                                        return SizedBox();
                                      }
                                      var data =
                                          tokenData["result"]["value"][0];
                                      var amount =
                                          NumberFormat.compact().format(
                                        num.parse(
                                          data["account"]["data"]["parsed"]
                                                      ["info"]["tokenAmount"]
                                                  ["uiAmount"]
                                              .toString(),
                                        ),
                                      );
                                      if (amount == "0") {
                                        return SizedBox();
                                      }
                                      return ListTile(
                                        leading: Image.asset(
                                          tokenAddress[index]["image"]
                                              .toString(),
                                          fit: BoxFit.cover,
                                        ),
                                        title: Text(
                                          tokenAddress[index]["name"]
                                              .toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              amount,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              " " +
                                                  tokenAddress[index]["symbol"]
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              }),
                        ),
                      ),
                    SizedBox(height: 20),
                    // if (checkSub == null ||
                    //     checkSub!.subscription == null &&
                    //         isLoading.value == false)
                    //   Column(
                    //     children: [
                    //       Image.asset(
                    //         subscriptionLogo,
                    //         height: 200,
                    //       ),
                    //       const SizedBox(height: 30),
                    //       Text(
                    //         "Access premium VPN and enhanced security.",
                    //         // subscribeSubTxt,
                    //         style: TextStyle(),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //       const SizedBox(height: 20),
                    //       ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //             backgroundColor: Color(0xff0162FF)),
                    //         onPressed: () async {
                    //           // Get.to(() => InAppPurchasePage());
                    //           await ApiController().trialSubscription();
                    //           checkSubscription();
                    //         },
                    //         child: Text(
                    //           // " Subscribe Erebrus Pro Plan ",
                    //           " ${freeTrial} ",
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //       )
                    //     ],
                    //   )
                    // else
                    //   InkWell(
                    //     onTap: () {
                    //       isSelectedIndex.value = 3;
                    //       setState(() {});
                    //     },
                    //     child: Card(
                    //       child: Column(
                    //         children: [
                    //           const SizedBox(height: 20),
                    //           Padding(
                    //             padding: const EdgeInsets.only(
                    //                 left: 20, right: 20),
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 const Text(
                    //                   "Free Trial",
                    //                   style: TextStyle(
                    //                     fontSize: 20,
                    //                   ),
                    //                 ),
                    //                 Obx(() => (isSelectedIndex.value == 3)
                    //                     ? Icon(
                    //                         Icons.check_circle,
                    //                         color: Colors.green,
                    //                       )
                    //                     : SizedBox())
                    //               ],
                    //             ),
                    //           ),
                    //           ListTile(
                    //             title: const Text("Status"),
                    //             trailing: Text(checkSub!.status
                    //                 .toString()
                    //                 .toUpperCase()),
                    //             dense: true,
                    //           ),
                    //           ListTile(
                    //             title: const Text("Start Time",
                    //                 style: TextStyle(color: Colors.green)),
                    //             trailing: Text(checkSub!
                    //                 .subscription!.startTime
                    //                 .toString()
                    //                 .split(" ")[0]),
                    //             dense: true,
                    //           ),
                    //           ListTile(
                    //             title: const Text(
                    //               "End Time",
                    //               style: TextStyle(color: Colors.red),
                    //             ),
                    //             trailing: Text(checkSub!.subscription!.endTime
                    //                 .toString()
                    //                 .split(" ")[0]),
                    //             dense: true,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // SizedBox(height: 30),
                    // if (checkSub != null &&
                    //     checkSub!.status.toString() == "expired")
                    //   ElevatedButton(
                    //       onPressed: () async {
                    //         await ApiController().trialSubscription();
                    //         checkSubscription();
                    //         // launchUrl(
                    //         //     Uri.parse("https://erebrus.io/subscription"));
                    //       },
                    //       child: Text("Renew Subscription")),
                  ],
                ),
        ),
      ),
    );
  }
}
