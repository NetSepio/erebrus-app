import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:erebrus_app/ai/aivoice.dart';
import 'package:erebrus_app/view/dwifi/dmap.dart';
import 'package:erebrus_app/view/subscription/subscriptionScreen.dart';
import 'package:erebrus_app/view/vpn/vpn_home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  List<Widget> pages = [
    const VpnHomeScreen(),
    const MapSample(),
    VoiceChatBot(),
    // const SubscriptionScreen(),
  ];
  @override
  void initState() {
     Geolocator.requestPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "Near WiFi"),
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_outlined), label: "Assistant"),
        ],
        onTap: (value) {
          currentIndex = value;
          setState(() {});
        },
      ),
    );
  }
}
