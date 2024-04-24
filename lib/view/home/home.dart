import 'dart:convert';
import 'dart:developer';

import 'package:aptos/aptos.dart';
import 'package:aptos/coin_client.dart';
import 'package:aptos/constants.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed25519;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wire/api/api.dart';
import 'package:wire/config/secure_storage.dart';
import 'package:wire/view/bottombar/bottombar.dart';
import 'package:wire/view/home/home_controller.dart';
import 'package:wire/view/home/verify.dart';
import 'package:wire/view/vpn/vpn_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();
  final storage = SecureStorage();

  @override
  void initState() {
    // aptosLogin();
    homeController.getProfileData();
    // log("token -- " + box!.get("token"));
    super.initState();
  }

  final aptosClient = AptosClient(Constants.devnetAPI, enableDebugLog: true);
  var balance;

  // aptosLogin() async {
  //   String mnemonics = await storage.getStoredValue("mnemonic") ?? "";
  //   log(mnemonics.toString());
  //   final sender = AptosAccount.generateAccount(mnemonics);
  //   // Check and fund account
  //   final amount = BigInt.from(10000000);
  //   bool isExists = await aptosClient.accountExist(sender.address);
  //   if (!isExists) {
  //     final faucetClient =
  //         FaucetClient.fromClient(Constants.faucetDevAPI, aptosClient);
  //     await faucetClient.fundAccount(sender.address, amount.toString());
  //     await Future.delayed(const Duration(seconds: 2));
  //   }
  //   final account = AptosAccount(
  //       Uint8List.fromList(HEX.decode(privateKeyFromMnemonic(mnemonics))));
  //   final hexBytes = account.accountAddress.toUint8Array();

  //   final privateKeyBytes =
  //       HexString(privateKeyFromMnemonic(mnemonics)).toUint8Array();
  //   final signingKey = ed25519.PrivateKey(privateKeyBytes);
  //   final signEncode = ed25519.sign(signingKey, hexBytes).sublist(
  //         0,
  //       );
  //   Signature signature = Signature(
  //       type: "ed25519_signature",
  //       publicKey: account.pubKey().hex(),
  //       signature: "0x${HEX.encode(signEncode)}");
  //   log("signature -- >  ${signature.signature}");
  // homeController.getPerseto(
  //   walletAddress: sender.address,
  //   signature: signature.signature.toString(),
  // );

  //   final coinClient = CoinClient(aptosClient);

  //   // Check account balance
  //   balance = await coinClient.checkBalance(sender.address);
  //   log("balance -- $balance");
  //   setState(() {});
  // }

  aptosLogin() async {
    String mnemonics = await storage.getStoredValue("mnemonic") ?? "";
    var pvtKey = await storage.getStoredValue('pvtKey');
    final sender = AptosAccount.generateAccount(mnemonics);

    log("Wallet Address ${sender.accountAddress.hex()}");
    var res = await homeController.getPerseto(walletAddress: sender.address);
    var message = res['payload']['eula'];
    var nonce = res['payload']['flowId'];
    var payload = {'message': message, 'nonce': nonce};

    var signKey = ed25519.sign(
        sender.signingKey.privateKey, utf8.encode(payload.toString()));

    var keyPair = sender.signingKey;
    var publicKey = keyPair.publicKey;
    var verify =
        ed25519.verify(publicKey, utf8.encode(payload.toString()), signKey);
    log("Verify ---  $verify");
    log("publicKeyHex ---  ${sender.pubKey().hex()}");
    log("signature -- > 0x${HEX.encode(signKey)}");
    log("message:--  $message");
    log("payload:--  $payload");

    // var signKeyBytes = ed25519.sign(
    //     sender.signingKey.privateKey, utf8.encode(payload.toString()));
    // var signKeyHex = HEX.encode(signKeyBytes);
    // print('SignKey Hex: $signKeyHex');
    // var d = verifySignature(message, signKeyHex, sender.pubKey().hex());
    String signatureHex =
        "0x7d2c98d66041fdf6df028edf8bbc8f83279410e2b392e0e26d54db740abb23d6858d7fc54d1ce2be657488be7639f74046341393dbbf7c20d8611e6dd9f8070f"; // Replace with actual signature in hex format
    String publicKeyHex =
        "0xf16eee3e297c9208227f77dadb5bcfa4cdcf092b2f76e9c1dc1f3a3c59f9ed2c"; // Remove '0x' prefix if present and any non-hex characters

    
    var d = verifySignature(message, signatureHex, publicKeyHex);
    print("Signature verification result: $d");

    log("New Ver ---  $d");
    // ss.Signature signature = ss.Signature(
    //     type: "ed25519_signature",
    //     publicKey: sender.pubKey().hex(),
    //     signature: "0x${HEX.encode(signKe)}");

    await ApiController().getAuthenticate(
      flowid: nonce,
      signature: "0x${HEX.encode(signKey)}",
      walletAddress: sender.accountAddress.hex(),
    );

    final coinClient = CoinClient(aptosClient);

    // Check account balance
    balance = await coinClient.checkBalance(sender.address);
    log("balance -- $balance");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: ElevatedButton(
      //       onPressed: () {
      //         // aptosLogin();
      //       },
      //       child: const Text("data")),
      // ),
      body: GetBuilder<HomeController>(
        init: homeController,
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.profileModel != null &&
              controller.profileModel!.value.payload != null) {
            // return const VpnHomeScreen();
            return const BottomBar();
          } else {
            // return const BottomBar();
            return Scaffold(
              appBar: AppBar(
                title: const Text("Erebrus"),
                centerTitle: true,
              ),
              body: NoWalletFound(),
            );
          }
        },
      ),
    );
  }
}

class NoWalletFound extends StatelessWidget {
  const NoWalletFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: Get.width),
          Image.asset(
            "assets/images/sad.png",
            height: 100,
          ),
          const Text(
            "No Wallet found. Please link an Aptos Wallet to your profile.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          ElevatedButton(
              onPressed: () async {
                await launchUrl(
                    Uri.parse("https://app.netsepio.com/"));
              },
              child: const Text("link Wallet"))
        ],
      ),
    );
  }
}
