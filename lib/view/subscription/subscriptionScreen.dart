import 'package:dio/dio.dart';
import 'package:erebrus_app/api/api.dart';
import 'package:erebrus_app/config/assets.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/strings.dart';
import 'package:erebrus_app/model/CheckSubscriptionModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreen extends StatefulWidget {
  final bool showAppbar;
  const SubscriptionScreen({super.key, this.showAppbar = true});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  CheckSubscriptionModel? checkSub;
  RxBool isLoading = true.obs;
  RxInt isSelectedIndex = 0.obs;
  List nftSubscriptionMintAddress = [
    "2PxZ4tUKtT622TvbKWQ2bUtacaHATtQrmCkYcFuzxy5S",
    "FgS1q7Q4m1PF6v4PKYsQq6MfLZMxhucDkJdWwRqm7xwQ",
    "AwwNvkZisYzgquqiE2RUieiHtgJt5LsGVHUqzTDxJnSx",
    "CCW7TUdn5XZmcPVc2fNDrELZmpReefLPSk31cZ935nFx"
  ];

  @override
  void initState() {
    super.initState();
    checkSubscription();
  }

  var nftDta;
  getNfts() async {
    var res = await Dio().get(
        dotenv.get("NFT_API") + "/${box!.get("selectedWalletAddress")}/tokens");
    nftDta = res.data;
    setState(() {});
  }

  checkSubscription() async {
    EasyLoading.show();
    try {
      checkSub = await ApiController().checkSubscription();
      await getNfts();
      isLoading.value = false;
      setState(() {});
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppbar
          ? AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Subscriptions'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              actions: [
                // InkWell(
                //   onTap: () {
                //     Get.to(() => const SettingPage());
                //   },
                //   child: const Padding(
                //     padding: EdgeInsets.all(8.0),
                //     child: Icon(Icons.settings),
                //   ),
                // )
              ],
            )
          : null,
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
                    // if (nftDta != null &&
                    //     box!.get("selectedWalletName") == "Solana")
                    //   const Text(
                    //     "NFT Subscription",
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //     ),
                    //   ),
                    // if (nftDta != null &&
                    //     box!.get("selectedWalletName") == "Solana")
                    //   SizedBox(height: 10),
                    if (nftDta != null &&
                        box!.get("selectedWalletName") == "Solana")
                      Card(
                        child: ListView.separated(
                          itemCount: nftDta.length,
                          shrinkWrap: true,
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
                          separatorBuilder: (BuildContext context, int index) {
                            return nftSubscriptionMintAddress
                                    .contains(nftDta[index]["mintAddress"])
                                ? Divider(indent: 100, height: 20)
                                : SizedBox();
                          },
                        ),
                      ),
                    if (nftDta != null &&
                        box!.get("selectedWalletName") == "Solana")
                      SizedBox(height: 20),
                    if (checkSub == null ||
                        checkSub!.subscription == null &&
                            isLoading.value == false)
                      Column(
                        children: [
                          Image.asset(
                            subscriptionLogo,
                            height: 200,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "Access premium VPN and enhanced security.",
                            // subscribeSubTxt,
                            style: TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff0162FF)),
                            onPressed: () async {
                              // Get.to(() => InAppPurchasePage());
                              await ApiController().trialSubscription();
                              checkSubscription();
                            },
                            child: Text(
                              // " Subscribe Erebrus Pro Plan ",
                              " ${freeTrial} ",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )
                    else
                      InkWell(
                        onTap: () {
                          isSelectedIndex.value = 3;
                          setState(() {});
                        },
                        child: Card(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Free Trial",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Obx(() => (isSelectedIndex.value == 3)
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : SizedBox())
                                  ],
                                ),
                              ),
                              ListTile(
                                title: const Text("Status"),
                                trailing: Text(
                                    checkSub!.status.toString().toUpperCase()),
                                dense: true,
                              ),
                              ListTile(
                                title: const Text("Start Time",
                                    style: TextStyle(color: Colors.green)),
                                trailing: Text(checkSub!.subscription!.startTime
                                    .toString()
                                    .split(" ")[0]),
                                dense: true,
                              ),
                              ListTile(
                                title: const Text(
                                  "End Time",
                                  style: TextStyle(color: Colors.red),
                                ),
                                trailing: Text(checkSub!.subscription!.endTime
                                    .toString()
                                    .split(" ")[0]),
                                dense: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 30),
                    if (checkSub!.status.toString() == "expired")
                      ElevatedButton(
                          onPressed: () {
                            launchUrl(
                                Uri.parse("https://erebrus.io/subscription"));
                          },
                          child: Text("Renew Subscription")),
                  ],
                ),
        ),
      ),
    );
  }
}
