import 'package:flutter/material.dart';
import 'package:wire/view/dwifi/dmap.dart';
import 'package:wire/view/subscription/subscriptionScreen.dart';
import 'package:wire/view/vpn/vpn_home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  List<Widget> pages = [
    const VpnHomeScreen(),
    // const MapSample(),
    // const VpnHomeOld(),
    const SubscriptionScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          // BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "WiFi"),
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_outlined), label: "Subscription"),
        ],
        onTap: (value) {
          currentIndex = value;
          setState(() {});
        },
      ),
    );
  }
}
