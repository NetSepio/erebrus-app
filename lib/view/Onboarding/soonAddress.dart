// import 'dart:typed_data';

// import 'package:bip39/bip39.dart' as bip39;
// import 'package:ed25519_hd_key/ed25519_hd_key.dart';
// import 'package:solana/solana.dart';
// import 'package:erebrus_app/config/common.dart';

// class WalletGenerator {
//   // Generate a new random mnemonic
//   static String generateMnemonic() {
//     return bip39.generateMnemonic();
//   }

//   // Create a Solana wallet from a mnemonic
//   static Future<Ed25519HDKeyPair> createWalletFromMnemonic(
//       String mnemonic) async {
//     // Validate mnemonic
//     if (!bip39.validateMnemonic(mnemonic)) {
//       throw ArgumentError('Invalid mnemonic');
//     }

//     // Convert mnemonic to seed
//     Uint8List seed = bip39.mnemonicToSeed(mnemonic);

//     // Derive Solana derivation path (m/44'/501'/0'/0')
//     final hdKey = await ED25519_HD_KEY.derivePath("m/44'/501'/0'/0'", seed);

//     // Create Solana keypair
//     return await Ed25519HDKeyPair.fromPrivateKeyBytes(privateKey: hdKey.key);
//   }

//   // Get public address from mnemonic
//   static Future<String> getAddressFromMnemonic(String mnemonic) async {
//     final wallet = await createWalletFromMnemonic(mnemonic);
//     return wallet.address;
//   }
// }

// getSoonAddress(mnemonic) async {
//   try {
    
//   if (box!.containsKey("SoonAddress") == false ||
//       box!.get("SoonAddress") == null) {
//     var soon = await WalletGenerator.getAddressFromMnemonic(mnemonic);
//     box!.put("SoonAddress", soon.toString());
//     print("----=-===-===-=$soon");
//   }

//   } catch (e) {
    
//   }
// }
