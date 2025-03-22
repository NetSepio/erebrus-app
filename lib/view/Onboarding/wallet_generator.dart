import 'dart:typed_data';

import 'package:aptos/aptos.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:solana/solana.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class WalletGenerator {
  static String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  // Create a Solana wallet from a mnemonic
  static Future<Ed25519HDKeyPair> createWalletFromMnemonic(
      String mnemonic) async {
    // Validate mnemonic
    if (!bip39.validateMnemonic(mnemonic)) {
      throw ArgumentError('Invalid mnemonic');
    }

    // Convert mnemonic to seed
    Uint8List seed = bip39.mnemonicToSeed(mnemonic);

    // Derive Solana derivation path (m/44'/501'/0'/0')
    final hdKey = await ED25519_HD_KEY.derivePath("m/44'/501'/0'/0'", seed);

    // Create Solana keypair
    return await Ed25519HDKeyPair.fromPrivateKeyBytes(privateKey: hdKey.key);
  }

  // Get public address from mnemonic
  static Future<String> getAddressFromMnemonic(String mnemonic) async {
    final wallet = await createWalletFromMnemonic(mnemonic);
    return wallet.address;
  }
}

getSoonAddress(mnemonic) async {
  if (box!.containsKey("SoonAddress") == false ||
      box!.get("SoonAddress") == null) {
    var soon = await WalletGenerator.getAddressFromMnemonic(mnemonic);
    box!.put("SoonAddress", soon.toString());
    print("----=-===-===-=$soon");
  }
}

Future getEclipseAddress(mnemonic) async {
  if (box!.containsKey("EclipseAddress") == false ||
      box!.get("EclipseAddress") == null) {
    final wallet = await WalletGenerator.getAddressFromMnemonic(mnemonic);

    box!.put("EclipseAddress", wallet);
  }
}

Future getSolanaAddress(mnemonic) async {
  if (box!.containsKey("solanaAddress") == false ||
      box!.get("solanaAddress") == null) {
    final wallet = await WalletGenerator.getAddressFromMnemonic(mnemonic);

    box!.put("solanaAddress", wallet);
  }
}

// SuiAccount? ed25519;
suiWal(mnemonics) async {
  if (box!.containsKey("suiAdd") == false || box!.get("suiAdd") == null) {
    var wallet = await WalletGenerator.getAddressFromMnemonic(mnemonics);
    // final secp256k1 =
    //     SuiAccount.fromMnemonics(mnemonics, SignatureScheme.Secp256k1);
    // log("suiAdd--${ed25519!.getAddress().toString()}");
    box!.put("suiAdd", wallet);
  }
}

var evmWalletAddress;
var aptosWalletAddress;
Future evmAptos(mnemonic) async {
  try {
    final seed = bip39.mnemonicToSeed(mnemonic);
    // await getEvmWallet(mnemonic);

    if (box!.containsKey("aptosAddress") == false ||
        box!.get("aptosAddress") == null) {
      final evmPrivateKey =
          EthPrivateKey.fromHex(bytesToHex(seed.sublist(0, 32)));
      evmWalletAddress = evmPrivateKey.address.hex;
      box!.put("aptosAddress", evmWalletAddress.toString());
      print("EVM Wallet Address: $evmWalletAddress");
    }

    // Derive Aptos Wallet Address
    if (box!.containsKey("aptosAdd") == false || box!.get("aptosAdd") == null) {
      final aptosPrivateKey = AptosAccount.generateAccount(mnemonic);
      aptosWalletAddress = aptosPrivateKey.accountAddress;
      box!.put("aptosAdd", aptosWalletAddress.toString());
      print("Aptos Wallet Address: $aptosWalletAddress");
    }
  } catch (e) {}
}
