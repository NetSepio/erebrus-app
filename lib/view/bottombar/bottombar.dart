import 'package:flutter/material.dart';
import 'package:wire/view/profile/profile_page.dart';
import 'package:wire/view/speedCheck/speedCheck.dart';
import 'package:wire/view/vpn/vpn_home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  List<Widget> pages = [
    const SpeedCheck(),
    const VpnHomeScreen(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.speed), label: "Speed"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        onTap: (value) {
          currentIndex = value;
          setState(() {});
        },
      ),
    );
  }
}
