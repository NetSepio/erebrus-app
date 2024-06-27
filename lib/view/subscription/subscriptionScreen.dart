import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wire/api/api.dart';
import 'package:wire/model/CheckSubModel.dart';
import 'package:wire/view/setting/setting.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

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
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.settings),
            ),
          )
        ],
      ),
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
                    if (checkSub == null ||
                        checkSub!.subscription == null &&
                            isLoading.value == false)
                      Column(
                        children: [
                          Image.asset("assets/Brazuca_Sitting.png"),
                          const SizedBox(height: 30),
                          const Text(
                            "Subscribe and Unlock Full Access,\nLog In to Get Started",
                            style: TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () async {
                              await ApiController().trialSubscription();
                              checkSubscription();
                            },
                            child: const Text(
                              " Try our free trial now ",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )
                    else
                      Card(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Trial Subscription",
                              style: TextStyle(
                                fontSize: 20,
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
                      )
                  ],
                ),
        ),
      ),
    );
  }
}
