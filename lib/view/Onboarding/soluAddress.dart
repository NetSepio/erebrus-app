// import 'dart:developer';
// import 'dart:typed_data';

// import 'package:convert/convert.dart';
// import 'package:pointycastle/digests/sha3.dart';
// import 'package:wire/config/common.dart';

// /// Base58 alphabet
// const String _base58Alphabet =
//     '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

// /// Decode a Base58 string to Uint8List
// Uint8List base58Decode(String input) {
//   BigInt decoded = BigInt.zero;
//   for (int i = 0; i < input.length; i++) {
//     final index = _base58Alphabet.indexOf(input[i]);
//     if (index == -1) {
//       throw FormatException("Invalid Base58 character: ${input[i]}");
//     }
//     decoded = decoded * BigInt.from(58) + BigInt.from(index);
//   }

//   final result = <int>[];
//   while (decoded > BigInt.zero) {
//     result.insert(0, (decoded & BigInt.from(0xff)).toInt());
//     decoded = decoded >> 8;
//   }

//   // Handle leading zeros in the Base58 string
//   for (int i = 0; i < input.length && input[i] == '1'; i++) {
//     result.insert(0, 0);
//   }

//   return Uint8List.fromList(result);
// }

// /// Custom Base58 Encoder
// String base58Encode(Uint8List input) {
//   BigInt number = BigInt.parse(hex.encode(input), radix: 16);
//   final base = BigInt.from(58);
//   final result = <String>[];

//   while (number > BigInt.zero) {
//     final remainder = number % base;
//     number = number ~/ base;
//     result.insert(0, _base58Alphabet[remainder.toInt()]);
//   }

//   // Handle leading zeros in input by adding '1'
//   for (int i = 0; i < input.length && input[i] == 0; i++) {
//     result.insert(0, _base58Alphabet[0]);
//   }

//   return result.join();
// }

// /// Compute SHA3-256 Hash
// Uint8List sha3_256(Uint8List input) {
//   final sha3 = SHA3Digest(256);
//   return Uint8List.fromList(sha3.process(input));
// }

// /// Derive a Soul Wallet Address from Ed25519HD Public Key
// String deriveSoulWallet(String ed25519HDPublicKey) {
//   // Decode the Base58 public key into Uint8List
//   final publicKeyBytes = base58Decode(ed25519HDPublicKey);

//   // Hash the public key using SHA3-256
//   final sha3Hash = sha3_256(publicKeyBytes);

//   // Encode the hash into Base58 to form the wallet address
//   final soulWalletAddress = base58Encode(sha3Hash);

//   return soulWalletAddress;
// }

// soulAddress({ed25519HDPublicKey}) {
//   // Derive the Soul Wallet Address
//   final soulWalletAddress = deriveSoulWallet(ed25519HDPublicKey);
//   box!.put("soulAddress", soulWalletAddress);
//   log("---- ===  Soul Wallet Address: $soulWalletAddress");
// }
