import 'dart:math';

import 'package:bip39/bip39.dart' as bip39;
import 'package:hdkey/hdkey.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wire/config/common.dart';

eclipAddress(mnemonic) async {
  // Validate Mnemonic
  if (!bip39.validateMnemonic(mnemonic)) {
    print("Invalid mnemonic");
    return;
  }

  // Convert Mnemonic to Seed
  final seed = bip39.mnemonicToSeed(mnemonic);

  // Derive Private Key Using Ethereum Derivation Path
  final derivationPath = "m/44'/60'/0'/0/0";
  final hdKey = HDKey.fromMasterSeed(seed);
  final childKey = hdKey.derive(derivationPath);

  final privateKeyBytes = childKey.privateKey!;
  final privateKey =
      EthPrivateKey.fromHex(privateKeyBytesToHex(privateKeyBytes));

  // Generate Wallet Address
  final address = await privateKey.extractAddress();
  print("Eclipse Wallet Address: ${address.hexEip55}");
  box!.put("EclipseAdd", address.hexEip55.toString());
  // Encrypt the Wallet (Optional)
  final wallet = Wallet.createNew(privateKey, "your-password", Random.secure());
  print("Encrypted Wallet: ${wallet.toJson()}");
}

// Helper Function: Convert Private Key Bytes to Hex
String privateKeyBytesToHex(List<int> privateKeyBytes) {
  return privateKeyBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
