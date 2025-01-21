import 'package:erebrus_app/ai/aivoice.dart';
import 'package:erebrus_app/view/profile/profile.dart';
import 'package:erebrus_app/view/vpn/vpn_home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
    VoiceChatBot(),
    Profile(title: "EREBRUS", showBackArrow: false),

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
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Color.fromARGB(255, 47, 116, 227),
          ),
          SalomonBottomBarItem(
            icon: Image.asset(
              "assets/Erebrus_AI_Cyrene.png",
              width: 22,
            ),
            title: Text("Cyrene"),
            selectedColor: Color(0xff0162FF),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
    // BottomNavigationBar(
    //   currentIndex: currentIndex,
    //   items: const [
    //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    //     // BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "Near WiFi"),
    //     BottomNavigationBarItem(
    //         icon: Icon(Icons.subscriptions_outlined), label: "Assistant"),
    //   ],
    //   onTap: (value) {
    //     currentIndex = value;
    //     setState(() {});
    //   },
    // ),
    // );
  }
}
