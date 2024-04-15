import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wire/config/common.dart';
import 'package:wire/config/theme.dart';
import 'package:wire/view/home/home.dart';

class AuthCompleteScreen extends StatelessWidget {
  const AuthCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "",
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Do Remember!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              height(15),
              const Divider(),
              height(15),
              const ListTile(
                leading: Icon(Icons.vpn_key),
                title: Text(
                  "The Mnemonic is the key to your wallet",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Obtaining your mnemonic means obtaining your assets",
                  style: TextStyle(
                    color: blueGray,
                  ),
                ),
              ),
              height(20),
              const ListTile(
                leading: Icon(Icons.edit),
                title: Text(
                  "Transcribe the Mnemonics",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Do not make copies or take screenshots.",
                  style: TextStyle(
                    color: blueGray,
                  ),
                ),
              ),
              height(20),
              const ListTile(
                leading: Icon(Icons.health_and_safety),
                title: Text(
                  "Store in a safe place",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Once lost, the assets cannot be recovered",
                  style: TextStyle(
                    color: blueGray,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: true,
              dense: true,
              activeColor: Colors.blue.shade900,
              onChanged: (v) {},
              title: const Text(
                "I Understand that I am responsible for the security of my mnemonic.",
                style: TextStyle(fontWeight: FontWeight.w100),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.offAll(() => const HomeScreen());
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Done"),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
