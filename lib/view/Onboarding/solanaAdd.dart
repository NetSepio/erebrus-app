import 'dart:developer';

import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';
import 'package:wire/config/common.dart';

class SolanaWalletGenerator {
  /// Generates a Solana wallet from a mnemonic phrase
  static Future<Map<String, String>> getWalletFromMnemonic(
      String mnemonic) async {
    try {
      // Validate mnemonic
      if (!bip39.validateMnemonic(mnemonic)) {
        throw Exception('Invalid mnemonic phrase');
      }

      // Convert mnemonic to seed
      final seed = bip39.mnemonicToSeed(mnemonic);

      // Derive the ED25519 private key using BIP44 derivation path for Solana
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
}

// Example usage:
Future getSolanaAddress(mnemonic) async {
  // Generate new mnemonic
  // final mnemonic = SolanaWalletGenerator.generateMnemonic();
  final mnemonic =
      "world broom wife avocado excite dutch runway void venture fit nose tenant";

  // Get wallet from mnemonic
  final wallet = await SolanaWalletGenerator.getWalletFromMnemonic(mnemonic);
  log('solana Public Key: ${wallet['publicKey']}');
  log('solana Private Key: ${wallet['privateKey']}');
  box!.put("solanaAdd", wallet['publicKey'].toString());
}
