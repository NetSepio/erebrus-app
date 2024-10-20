import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wire/api/api.dart';
import 'package:wire/config/secure_storage.dart';
import 'package:wire/config/strings.dart';
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
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(profileTxt),
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
                            children: [
                              Image.asset(
                                "assets/solo.png",
                                width: 40,
                              ),
                              SizedBox(width: 5),
                              Obx(() => Expanded(
                                    child: TextField(
                                      readOnly: true,
                                      maxLines: 2,
                                      controller: TextEditingController(
                                          text: solanaAdd.value.toString()),
                                      decoration: InputDecoration(
                                        labelText: "Solana Wallet",
                                        filled: true,
                                        fillColor: Colors.black,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (profileModel!.payload!.walletAddress != null)
                            Row(
                              children: [
                                Image.asset(
                                  "assets/evm.png",
                                  width: 40,
                                  height: 40,
                                ),
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
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
