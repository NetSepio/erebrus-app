import 'package:aptos/aptos.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sui/cryptography/signature.dart';
import 'package:sui/sui_account.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
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

  SuiAccount? ed25519;
  suiWal() async {
    /// create mnemonics
    var mnemonics = await storage.getStoredValue("mnemonic") ?? "";

    /// Ed25519 account
    ed25519 = SuiAccount.fromMnemonics(mnemonics, SignatureScheme.Ed25519);

    /// Secp256k1 account
    final secp256k1 =
        SuiAccount.fromMnemonics(mnemonics, SignatureScheme.Secp256k1);

    /// Secp256r1 account
    final secp256r1 =
        SuiAccount.fromMnemonics(mnemonics, SignatureScheme.Secp256r1);
    setState(() {});
  }

  var aptosWalletAddress;
  var evmWalletAddress;
  void deriveWalletAddresses() async {
    var mnemonic = await storage.getStoredValue("mnemonic") ?? "";
    final seed = bip39.mnemonicToSeed(mnemonic);

    // Derive EVM Wallet Address
    final evmPrivateKey =
        EthPrivateKey.fromHex(bytesToHex(seed.sublist(0, 32)));
    evmWalletAddress = evmPrivateKey.address.hex;
    print("EVM Wallet Address: $evmWalletAddress");

    // Derive Aptos Wallet Address
    final aptosPrivateKey = AptosAccount.generateAccount(mnemonic);
    ;
    aptosWalletAddress = aptosPrivateKey.accountAddress;
    print("Aptos Wallet Address: $aptosWalletAddress");
  }

  @override
  void initState() {
    apiCall();
    getSolanaAddress();
    suiWal();
    deriveWalletAddresses();
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
              // : profileModel!.payload == null
              //     ? const SizedBox()
              : Container(
                  child: Column(
                    children: [
                      if (ed25519 != null)
                        Row(
                          children: [
                            Image.asset(
                              "assets/sui.png",
                              width: 35,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                maxLines: 3,
                                controller: TextEditingController(
                                    text: ed25519!.getAddress().toString()),
                                decoration: InputDecoration(
                                  labelText: "Sui Wallet",
                                  filled: true,
                                  fillColor: Colors.black,
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
                      if (solanaAdd.value.isNotEmpty) SizedBox(height: 20),
                      if (solanaAdd.value.isNotEmpty)
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
                      if (evmWalletAddress != null)
                        Row(
                          children: [
                            Image.asset(
                              "assets/evm.png",
                              width: 30,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                maxLines: 2,
                                controller: TextEditingController(
                                    text: evmWalletAddress.toString()),
                                decoration: InputDecoration(
                                  labelText: "EVM Address",
                                  filled: true,
                                  fillColor: Colors.black,
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
                      SizedBox(
                        height: 20,
                      ),
                      if (aptosWalletAddress != null)
                        Row(
                          children: [
                            Image.asset(
                              "assets/app.png",
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                maxLines: 2,
                                controller: TextEditingController(
                                    text: aptosWalletAddress.toString()),
                                decoration: const InputDecoration(
                                  labelText: "APTOS Wallet",
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
                            labelText: profileModel!.payload!.email.toString(),
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
