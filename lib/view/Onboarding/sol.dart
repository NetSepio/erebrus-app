import 'dart:developer';

import 'package:bip39/bip39.dart' as bip39;
import 'package:solana/solana.dart';

Future<String> generateSolanaAddress(String mnemonic) async {
  // Generate seed from mnemonic
  final seed = bip39.mnemonicToSeed(mnemonic);

  // Create Ed25519 keypair from the seed
  final wallet = await Ed25519HDKeyPair.fromMnemonic(mnemonic);

  // Get the public address
  final solanaAddress = wallet.address;

  log('Your Solana address is: $solanaAddress');
  return await solanaAddress;
}
