import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wire/api/api.dart';
import 'package:wire/config/secure_storage.dart';
import 'package:wire/view/profile/profile_model.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileModel? profileModel;
  RxString solanaAdd = "".obs;
  final storage = SecureStorage();

  apiCall() async {
    profileModel = await ApiController().getProfile();
    setState(() {});
  }

  getSolanaAddress() async {
    solanaAdd.value = await storage.getStoredValue("solanaAddress") ?? "";
  }

  @override
  void initState() {
    apiCall();
    getSolanaAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //       image: AssetImage("assets/bgLogo.jpg"),
      //       fit: BoxFit.fitHeight,
      //       colorFilter: ColorFilter.mode(Colors.black12, BlendMode.colorBurn)),
      // ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: profileModel == null
              ? const Center(child: CircularProgressIndicator())
              : profileModel!.payload == null
                  ? const SizedBox()
                  : Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/evm.png",
                                width: 40,
                                height: 40,
                              ),
                              Image.asset(
                                "assets/sc.png",
                                width: 120,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          if (profileModel!.payload!.walletAddress != null)
                            Row(
                              children: [
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextField(
                                    readOnly: true,
                                    maxLines: 2,
                                    controller: TextEditingController(
                                        text: profileModel!
                                            .payload!.walletAddress
                                            .toString()),
                                    decoration: const InputDecoration(
                                      labelText: "EVM Wallet",
                                      filled: true,
                                      fillColor: Colors.black38,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          if (profileModel!.payload!.email != null)
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText:
                                    profileModel!.payload!.email.toString(),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          // Divider(indent: 10),
                          // SizedBox(height: 10),
                          // Image.asset(
                          //   "assets/solo.png",
                          //   width: 40,
                          // ),
                          // SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     SizedBox(width: 5),
                          //     Obx(() => Expanded(
                          //           child: TextField(
                          //             readOnly: true,
                          //             maxLines: 2,
                          //             controller: TextEditingController(
                          //                 text: solanaAdd.value.toString()),
                          //             decoration: InputDecoration(
                          //               labelText: "Solana Wallet",
                          //               filled: true,
                          //               fillColor: Colors.black,
                          //               border: OutlineInputBorder(
                          //                 borderSide: BorderSide(
                          //                   width: 1,
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         )),
                          //   ],
                          // ),
                          // SizedBox(height: 20),
                       
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
