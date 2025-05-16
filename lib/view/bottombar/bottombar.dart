import 'package:erebrus_app/view/browser/webbroweser.dart';
import 'package:erebrus_app/view/cyreneAi/agentSelect.dart';
import 'package:erebrus_app/view/cyreneAi/cyreneAi.dart';
import 'package:erebrus_app/view/home/home.dart';
import 'package:flutter/material.dart';
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
    AgentSelect(),
    // CyreneAi(),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        selectedItemColor: Colors.blueAccent,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.vpn_lock_outlined), label: ''
              // title: Text(""),
              // selectedColor: Color.fromARGB(255, 47, 116, 227),
              ),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/Erebrus_AI_Cyrene.png",
                width: 22,
              ),
              label: ''
              // title: Text(""),
              // selectedColor: Color(0xff0162FF),
              ),
          BottomNavigationBarItem(icon: Icon(Icons.web), label: ''
              // title: Text(""),
              // selectedColor: Colors.teal,
              ),
        ],
      ),
    );
  }
}
