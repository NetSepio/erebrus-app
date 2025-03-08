// Add these dependencies to pubspec.yaml:
// bip39: ^1.0.6
// ed25519_hd_key: ^2.2.1
// solana: ^0.30.0
// bs58: ^1.0.2

import 'dart:developer';

import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';

class EclipseWalletGenerator {
  /// Generates an Eclipse wallet from a mnemonic phrase
  static Future<Map<String, String>> getWalletFromMnemonic(
      String mnemonic) async {
    try {
      // Validate mnemonic
      if (!bip39.validateMnemonic(mnemonic)) {
        throw Exception('Invalid mnemonic phrase');
      }

      // Convert mnemonic to seed
      final seed = bip39.mnemonicToSeed(mnemonic);

      // Derive the ED25519 private key using Eclipse derivation path
      // Eclipse uses path: m/44'/1'/0'/0'
      final derivedKey = await ED25519_HD_KEY.derivePath(
        "m/44'/501'/0'/0'",
        seed,
      );

      // Create key pair from private key
      final keyPair = await Ed25519HDKeyPair.fromPrivateKeyBytes(
        privateKey: derivedKey.key,
      );

      return {
        'publicKey': keyPair.address,
        'privateKey': base58encode(derivedKey.key),
      };
    } catch (e) {
      throw Exception('Error generating wallet: $e');
    }
  }

  /// Generate a new random mnemonic phrase
  static String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  /// Validate an Eclipse address
  static bool isValidAddress(String address) {
    try {
      final decoded = base58decode(address);
      return decoded.length == 32;
    } catch (e) {
      return false;
    }
  }
}

// Example usage:
Future getEclipseAddress(mnemonic) async {
  // Get Eclipse wallet from mnemonic
  try {
    if (box!.containsKey("EclipseAddress") == false ||
        box!.get("EclipseAddress") == null) {
      final wallet =
          await EclipseWalletGenerator.getWalletFromMnemonic(mnemonic);
      log('Eclip Public Key: ${wallet['publicKey']}');
      log('Eclip Private Key: ${wallet['privateKey']}');
      box!.put("EclipseAddress", wallet['publicKey']);
      // Validate an address
      final isValid =
          EclipseWalletGenerator.isValidAddress(wallet['publicKey']!);
      log('Is valid address: $isValid');
    }
  } catch (e) {}
}
