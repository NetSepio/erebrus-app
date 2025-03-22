import 'package:erebrus_app/view/browser/webbroweser.dart';
import 'package:erebrus_app/view/cyreneAi/cyreneAi.dart';
import 'package:erebrus_app/view/home/home.dart';
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
    CyreneAi(),
    InAppWebViewScreen(),
    // Profile(
    //   title: "EREBRUS",
    //   showBackArrow: false,
    //   showSubscription: true,
    // ),

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
            icon: Icon(Icons.vpn_lock_outlined),
            title: Text(""),
            selectedColor: Color.fromARGB(255, 47, 116, 227),
          ),
          SalomonBottomBarItem(
            icon: Image.asset(
              "assets/Erebrus_AI_Cyrene.png",
              width: 22,
            ),
            title: Text(""),
            selectedColor: Color(0xff0162FF),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text(""),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
