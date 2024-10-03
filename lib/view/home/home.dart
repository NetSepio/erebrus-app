import 'dart:developer';

import 'package:aptos/aptos.dart';
import 'package:aptos/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wire/config/secure_storage.dart';
import 'package:wire/view/Onboarding/sol.dart';
import 'package:wire/view/bottombar/bottombar.dart';
import 'package:wire/view/home/home_controller.dart';

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
    homeController.getProfileData();
    solanaAddress();
    // log("token -- " + box!.get("token"));
    super.initState();
  }

  solanaAddress() async {
    String mnemonics = await storage.getStoredValue("mnemonic") ?? "";
    log("mnemonics ---- ${mnemonics}");
    var sd = await generateSolanaAddress(mnemonics);
    log("Solana Address- $sd");
    storage.writeStoredValues("solanaAddress", sd);
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

  // aptosLogin() async {
  // String mnemonics = await storage.getStoredValue("mnemonic") ?? "";
  // var pvtKey = await storage.getStoredValue('pvtKey');
  // final sender = AptosAccount.generateAccount(mnemonics);

  // log("Wallet Address $pvtKey");
  // log("Wallet Address hex ${sender.accountAddress.hex()}");
  // var res = await homeController.getPerseto(walletAddress: sender.address);

  // var message = res['payload']['eula'];
  // var nonce = res['payload']['flowId'];
  // var payload = {'message': message + nonce, 'account': pvtKey};
  // var pp = message + nonce;
  // var signKey =
  //     ed25519.sign(sender.signingKey.privateKey, utf8.encode(pp.toString()));

  // var keyPair = sender.signingKey;
  // var publicKey = keyPair.publicKey;
  // var verify = ed25519.verify(publicKey, utf8.encode(pp.toString()), signKey);
  // log("Verify ---  $verify");
  // log("publicKeyHex ---  ${sender.pubKey().hex()}");
  // log("signature -- > 0x${HEX.encode(signKey)}");
  // // log("message:--  $message");
  // log("payload:--  $pp");

  // var signKeyBytes = ed25519.sign(
  //     sender.signingKey.privateKey, utf8.encode(payload.toString()));
  // var signKeyHex = HEX.encode(signKeyBytes);

  // print('SignKey Hex: $signKeyHex');
  // Signature signature = Signature(
  //     type: "ed25519_signature",
  //     publicKey: sender.pubKey().hex(),
  //     signature: signKeyHex);

  // await ApiController().getAuthenticate(
  //     flowid: nonce, walletAddress: pvtKey.toString(), pubKey: "");

  // final coinClient = CoinClient(aptosClient);

  // // Check account balance
  // balance = await coinClient.checkBalance(sender.address);
  // log("balance -- $balance");
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                actions: const [],
              ),
              body: const NoWalletFound(),
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
                await launchUrl(Uri.parse("https://app.netsepio.com/"));
              },
              child: const Text("link Wallet"))
        ],
      ),
    );
  }
}
