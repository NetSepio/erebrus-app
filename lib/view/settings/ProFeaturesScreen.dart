import 'package:erebrus_app/api/api.dart';
import 'package:erebrus_app/model/CheckSubscriptionModel.dart';
import 'package:erebrus_app/view/bottombar/bottombar.dart';
import 'package:erebrus_app/view/inAppPurchase/inappP.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ProFeaturesScreen extends StatefulWidget {
  final bool fromLogin;
  const ProFeaturesScreen({Key? key, required this.fromLogin})
      : super(key: key);

  @override
  State<ProFeaturesScreen> createState() => _ProFeaturesScreenState();
}

class _ProFeaturesScreenState extends State<ProFeaturesScreen> {
  CheckSubscriptionModel? checkSub;
  checkSubscription() async {
    EasyLoading.show();
    try {
      checkSub = await ApiController().checkSubscription();
      setState(() {});
      if (widget.fromLogin) {
        if (checkSub!.status.toString().toLowerCase() == "active") {
          Get.offAll(() => BottomBar());
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    checkSubscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: (checkSub != null)
          ? Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.precision_manufacturing,
                        size: 40,
                        color: Color(0xff0162FF),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'PRO Features',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FeatureCard(
                      color: Colors.red.shade900,
                      icon: Icons.visibility_off,
                      title: 'Anonymous',
                      description: 'Hide your ip with\nanonymous surfing',
                    ),
                    FeatureCard(
                      color: Colors.purpleAccent.shade700,
                      icon: Icons.rocket_launch,
                      title: 'Fast',
                      description: 'Up to 1000 Mb/s\nbandwidth to explore',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FeatureCard(
                      color: Colors.blue.shade700,
                      icon: Icons.remove_circle_outline,
                      title: 'Remove Ads',
                      description: 'Enjoy the app\nwithout annoying ads',
                    ),
                    FeatureCard(
                      color: Colors.green.shade500,
                      icon: Icons.security,
                      title: 'Secure',
                      description: 'Transfer traffic via\nencrypted tunnel',
                    ),
                  ],
                ),
                const Spacer(),
                if (checkSub != null &&
                    checkSub!.status.toString() != "expired")
                  InkWell(
                    onTap: () async {
                      await ApiController().trialSubscription();
                      checkSubscription();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent.shade700,
                            Colors.deepPurpleAccent.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Get 7 Dat's Free Trial",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (checkSub != null &&
                    checkSub!.status.toString() == "expired")
                  Card(
                    child: const Text(
                      "Your Free Trial is Expired",
                      style: TextStyle(),
                    ),
                  ),
                const SizedBox(height: 10),
                const FreeTrialButton(),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final String description;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white54),
        ),
      ],
    );
  }
}
