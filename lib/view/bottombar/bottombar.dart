import 'package:erebrus_app/view/browser/webbroweser.dart';
import 'package:erebrus_app/view/cyreneAi/agentSelect.dart';
import 'package:erebrus_app/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:erebrus_app/config/colors.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 1; 
  final List<Widget> pages = [
   AgentSelect(),
    const HomeScreen(),
    // SettingsScreen(), // Replace with your Settings screen
   InAppWebViewScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: SizedBox(
        height: 110,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 24,
              right: 24,
              bottom: 10,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 4, 4, 42),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: blue.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => currentIndex = 0),
                        borderRadius: BorderRadius.circular(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/Erebrus_AI_Cyrene.png",width: 30,height: 30,),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 80), // Space for floating home button
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => currentIndex = 2),
                        borderRadius: BorderRadius.circular(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           Image.asset("assets/web.png",color: Colors.grey.shade300,width: 30,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating home button
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => currentIndex = 1),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: blue,
                     
                      boxShadow: [
                        BoxShadow(
                          color: appColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.home, color: white, size: 32),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
