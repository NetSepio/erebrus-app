// ignore_for_file: depend_on_referenced_packages, deprecated_member_use
import 'dart:async';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Web3 {
  late Credentials _credentials;
  late Web3Client _client;
  late Future<bool> _approveCb;
  late int _networkId;
  Web3(
    Future<bool> Function() approveCb, {
    String? url,
    int? networkId,
    String? defaultCommunityAddress,
    String? communityManagerAddress,
    String? transferManagerAddress,
    String? daiPointsManagerAddress,
    int? defaultGasLimit,
  }) {
    _client = Web3Client(getCurrentNetworkData['rpc_url'], Client());
    _networkId = networkId ?? getCurrentNetworkData['network_id'];
    _approveCb = approveCb();
  }

  static Map<String, dynamic> get getCurrentNetworkData {
    return {
      'rpc_url': dotenv.env["ETHEREUM_MAINNET_RPC"],
      'network_id': 1,
      'logo_path': 'assets/images/ethereum_logo.png',
      'symbol': 'ETH',
    };
  }

  static String privateKeyFromMnemonic(String mnemonic, {int childIndex = 0}) {
    String seed = bip39.mnemonicToSeedHex(mnemonic);
    bip32.BIP32 root =
        bip32.BIP32.fromSeed(Uint8List.fromList(HEX.decode(seed)));
    bip32.BIP32 child = root.derivePath("m/44'/60'/0'/0/$childIndex");
    String privateKey = HEX.encode(child.privateKey!.toList());
    return privateKey;
  }

  Future<void> setCredentials(String privateKey) async {
    _credentials = await _client.credentialsFromPrivateKey(privateKey);
  }

  Future<String> getAddress() async {
    return (await _credentials.extractAddress()).toString();
  }

  Future<EtherAmount> getBalance({String? address}) async {
    EthereumAddress a;
    if (address != null && address.isNotEmpty) {
      a = EthereumAddress.fromHex(address);
    } else {
      a = EthereumAddress.fromHex(await getAddress());
    }

    return await _client.getBalance(a);
  }
}
