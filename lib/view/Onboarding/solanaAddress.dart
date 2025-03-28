// import 'dart:developer';

// import 'package:aptos/aptos.dart';
// import 'package:bip39/bip39.dart' as bip39;
// import 'package:ed25519_hd_key/ed25519_hd_key.dart';
// import 'package:erebrus_app/config/common.dart';
// import 'package:solana/base58.dart';
// import 'package:solana/solana.dart';
// import 'package:sui/cryptography/signature.dart';
// import 'package:sui/sui_account.dart';
// import 'package:web3dart/crypto.dart';
// import 'package:web3dart/web3dart.dart';

// class SolanaWalletGenerator {
//   /// Generates a Solana wallet from a mnemonic phrase
//   static Future<Map<String, String>> getWalletFromMnemonic(
//       String mnemonic) async {
//     try {
//       // Validate mnemonic
//       if (!bip39.validateMnemonic(mnemonic)) {
//         throw Exception('Invalid mnemonic phrase');
//       }

//       // Convert mnemonic to seed
//       final seed = bip39.mnemonicToSeed(mnemonic);

//       // Derive the ED25519 private key using BIP44 derivation path for Solana
//       final derivedKey = await ED25519_HD_KEY.derivePath(
//         "m/44'/501'/0'/0'",
//         seed,
//       );

//       // Create key pair from private key
//       final keyPair = await Ed25519HDKeyPair.fromPrivateKeyBytes(
//         privateKey: derivedKey.key,
//       );

//       return {
//         'publicKey': keyPair.address,
//         'privateKey': base58encode(derivedKey.key),
//       };
//     } catch (e) {
//       throw Exception('Error generating wallet: $e');
//     }
//   }

//   /// Generate a new random mnemonic phrase
//   static String generateMnemonic() {
//     return bip39.generateMnemonic();
//   }
// }

// // Example usage:
// Future getSolanaAddress(mnemonic) async {
//   // Get wallet from mnemonic
//   try {
//     if (box!.containsKey("solanaAddress") == false ||
//         box!.get("solanaAddress") == null) {
//       final wallet =
//           await SolanaWalletGenerator.getWalletFromMnemonic(mnemonic);
//       log('solana Public Key: ${wallet['publicKey']}');
//       log('solana Private Key: ${wallet['privateKey']}');
//       box!.put("solanaAddress", wallet['publicKey'].toString());
//     }
//   } catch (e) {}
// }

// SuiAccount? ed25519;
// suiWal(mnemonics) async {
//   try {
//     if (box!.containsKey("suiAddress") == false ||
//         box!.get("suiAddress") == null) {
//       ed25519 =
//           await SuiAccount.fromMnemonics(mnemonics, SignatureScheme.Ed25519);
//       // final secp256k1 =
//       //     SuiAccount.fromMnemonics(mnemonics, SignatureScheme.Secp256k1);
//       // final secp256r1 =
//       //     SuiAccount.fromMnemonics(mnemonics, SignatureScheme.Secp256r1);
//       log("suiAddress--${ed25519!.getAddress().toString()}");
//       box!.put("suiAddress", ed25519!.getAddress().toString());
//     }
//   } catch (e) {}
// }

// var aptosWalletAddress;
// var evmWalletAddress;
// Future evmAptos(mnemonic) async {
//   try {
//     final seed = bip39.mnemonicToSeed(mnemonic);
//     // await getEvmWallet(mnemonic);

//     if (box!.containsKey("aptosAddress") == false ||
//         box!.get("aptosAddress") == null) {
//       final evmPrivateKey =
//           EthPrivateKey.fromHex(bytesToHex(seed.sublist(0, 32)));
//       evmWalletAddress = evmPrivateKey.address.hex;
//       box!.put("aptosAddress", evmWalletAddress.toString());
//       print("EVM Wallet Address: $evmWalletAddress");
//     }

//     // Derive Aptos Wallet Address
//     if (box!.containsKey("aptosAdd") == false || box!.get("aptosAdd") == null) {
//       final aptosPrivateKey = AptosAccount.generateAccount(mnemonic);
//       aptosWalletAddress = aptosPrivateKey.accountAddress;
//       box!.put("aptosAdd", aptosWalletAddress.toString());
//       print("Aptos Wallet Address: $aptosWalletAddress");
//     }
//   } catch (e) {}
// }
