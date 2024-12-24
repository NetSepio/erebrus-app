import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wire/api/api.dart';
import 'package:wire/config/assets.dart';
import 'package:wire/model/CheckSubscriptionModel.dart';
import 'package:wire/view/inAppPurchase/inappP.dart';

class SubscriptionScreen extends StatefulWidget {
  final bool showAppbar;
  const SubscriptionScreen({super.key, this.showAppbar = true});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  CheckSubModel? checkSub;
  RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    checkSubscription();
  }

  checkSubscription() async {
    EasyLoading.show();
    try {
      checkSub = await ApiController().checkSubscription();
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
                'Your Subscription'.toUpperCase(),
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
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(width: Get.width),
                    // if (checkSub == null ||
                    //     checkSub!.subscription == null &&
                    //         isLoading.value == false)
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
                            Get.to(() => InAppPurchasePage());
                            // await ApiController().trialSubscription();
                            // checkSubscription();
                          },
                          child: const Text(
                            " Subscribe Erebrus Pro Plan ",
                            // " ${freeTrial} ",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    )
                    // else
                    //   Card(
                    //     child: Column(
                    //       children: [
                    //         const SizedBox(height: 20),
                    //         const Text(
                    //           SubscriptionTxt,
                    //           style: TextStyle(
                    //             fontSize: 20,
                    //           ),
                    //         ),
                    //         ListTile(
                    //           title: const Text("Status"),
                    //           trailing: Text(
                    //               checkSub!.status.toString().toUpperCase()),
                    //           dense: true,
                    //         ),
                    //         ListTile(
                    //           title: const Text("Start Time",
                    //               style: TextStyle(color: Colors.green)),
                    //           trailing: Text(checkSub!.subscription!.startTime
                    //               .toString()
                    //               .split(" ")[0]),
                    //           dense: true,
                    //         ),
                    //         ListTile(
                    //           title: const Text(
                    //             "End Time",
                    //             style: TextStyle(color: Colors.red),
                    //           ),
                    //           trailing: Text(checkSub!.subscription!.endTime
                    //               .toString()
                    //               .split(" ")[0]),
                    //           dense: true,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // SizedBox(height: 30),
                    // if (checkSub!.status.toString() == "expired")
                    //   ElevatedButton(
                    //       onPressed: () {
                    //         launchUrl(
                    //             Uri.parse("https://erebrus.io/subscription"));
                    //       },
                    //       child: Text("Renew Subscription")),
                  ],
                ),
        ),
      ),
    );
  }
}
