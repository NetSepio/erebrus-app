
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:aptos/aptos.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:pointycastle/export.dart';
import 'package:wire/config/secure_storage.dart';

bool verifySignature(String message, String signature, String publicKey) {
  Digest sha256 = Digest('SHA-256');

  // Manually parse the DER-encoded signature
  ECSignature ecSignature =
      parseDERSignature(Uint8List.fromList(HEX.decode(signature)));

  // Manually parse the public key
  ECPoint publicKeyPoint = parsePublicKey(publicKey);

  Uint8List messageBytes = Uint8List.fromList(utf8.encode(message));

  // Initialize the signer with the parsed public key
  ECDSASigner signer = ECDSASigner(null, HMac(sha256, 64));
  signer.init(false,
      PublicKeyParameter(ECPublicKey(publicKeyPoint, ECCurve_secp256k1())));

  return signer.verifySignature(messageBytes, ecSignature);
}

// Function to parse DER-encoded signature bytes
ECSignature parseDERSignature(Uint8List derSignature) {
  BigInt r = byteArrayToBigInt(derSignature.sublist(4, 36));
  BigInt s = byteArrayToBigInt(derSignature.sublist(38));
  return ECSignature(r, s);
}

BigInt byteArrayToBigInt(Uint8List bytes) {
  BigInt result = BigInt.zero;
  for (int i = 0; i < bytes.length; i++) {
    result = result * BigInt.from(256) + BigInt.from(bytes[i]);
  }
  return result;
}

// Function to parse hex-encoded public key into an ECPoint
ECPoint parsePublicKey(String publicKeyHex) {
  BigInt x = BigInt.parse(publicKeyHex.substring(2, 66), radix: 16);
  BigInt y = BigInt.parse(publicKeyHex.substring(66), radix: 16);
  ECCurve curve = ECCurve_secp256k1() as ECCurve;
  return curve.createPoint(x, y);
}

