import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

class WalletGenerator {
  /// Derives Ethereum private key and address from a mnemonic phrase
  /// Returns a map containing the private key and wallet address
  static Future<Map<String, String>> getWalletFromMnemonic(
      String mnemonic) async {
    try {
      // Validate mnemonic
      if (!bip39.validateMnemonic(mnemonic)) {
        throw Exception('Invalid mnemonic phrase');
      }

      // Convert mnemonic to seed
      final seed = bip39.mnemonicToSeed(mnemonic);

      // Create BIP32 root from seed
      final root = bip32.BIP32.fromSeed(seed);

      // Derive the node based on Ethereum's BIP44 path
      // m/44'/60'/0'/0/0
      final child = root.derivePath("m/44'/60'/0'/0/0");

      // Get private key
      final privateKey = HEX.encode(child.privateKey!);

      // Create Ethereum credentials
      final credentials = EthPrivateKey.fromHex(privateKey);

      // Get Ethereum address
      final address = await credentials.extractAddress();

      return {
        'privateKey': privateKey,
        'address': address.hexEip55,
      };
    } catch (e) {
      throw Exception('Error generating wallet: $e');
    }
  }

  /// Generate a new random mnemonic phrase
  static String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  /// Validate a mnemonic phrase
  static bool validateMnemonic(String mnemonic) {
    return bip39.validateMnemonic(mnemonic);
  }
}

Future getEvmWallet(mnemonic) async {
// Get wallet from mnemonic

  try {
    // Validate mnemonic first
    if (WalletGenerator.validateMnemonic(mnemonic)) {
      final wallet = await WalletGenerator.getWalletFromMnemonic(mnemonic);
      print('Address: ${wallet['address']}');
      print('Private Key: ${wallet['privateKey']}');
    } else {
      print('Invalid mnemonic');
    }
  } catch (e) {
    print('Error: $e');
  }
}
