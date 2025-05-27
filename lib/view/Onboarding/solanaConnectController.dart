import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

class ClientController extends GetxController {
  late SolanaClient _solanaClient;

  final isMainnet = false.obs;
  final isRequestingAirdrop = false.obs;
  final capabilities = Rxn<GetCapabilitiesResult>();
  final authorizationResult = Rxn<AuthorizationResult>();

  @override
  void onInit() {
    super.onInit();
    _initializeClient();
  }

  void _initializeClient() {
    final rpcUrl = 'mainnet-beta';
    final websocketUrl = 'mainnet-beta';
    _solanaClient = SolanaClient(
      rpcUrl: Uri.parse(rpcUrl),
      websocketUrl: Uri.parse(websocketUrl),
    );
  }

  void updateNetwork({required bool useMainnet}) {
    if (isMainnet.value == useMainnet) return;
    isMainnet.value = useMainnet;
    _initializeClient();
  }

  Future<bool> isWalletAvailable() => LocalAssociationScenario.isAvailable();

  Future<void> requestCapabilities() async {
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    try {
      final client = await session.start();
      capabilities.value = await client.getCapabilities();
      await session.close();
    } catch (e) {
      print('-======================= qsfdfdsa');
    }
  }

  Future<void> authorize() async {
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    final client = await session.start();
    await _doAuthorize(client);
    await session.close();
  }

  Future<void> reauthorize() async {
    final authToken = authorizationResult.value?.authToken;
    if (authToken == null) return;

    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    final client = await session.start();
    await _doReauthorize(client);
    await session.close();
  }

  Future<void> deauthorize() async {
    final authToken = authorizationResult.value?.authToken;
    if (authToken == null) return;

    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    final client = await session.start();
    await client.deauthorize(authToken: authToken);
    await session.close();

    authorizationResult.value = null;
  }

  Future<void> requestAirdrop() async {
    final publicKey = authorizationResult.value?.publicKey;
    if (publicKey == null || isRequestingAirdrop.value) return;

    isRequestingAirdrop.value = true;
    try {
      await _solanaClient.requestAirdrop(
        address: Ed25519HDPublicKey(publicKey),
        lamports: lamportsPerSol,
      );
    } finally {
      isRequestingAirdrop.value = false;
    }
  }

  Future<void> signMessages(int number) async {
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    final client = await session.start();
    if (await _doReauthorize(client)) {
      final signer = publicKey!;
      final addresses = [signer.bytes].map(Uint8List.fromList).toList();

      final messages = _generateMessages(number: number, signer: signer)
          .map((e) => e
              .compile(recentBlockhash: '', feePayer: signer)
              .toByteArray()
              .toList())
          .map(Uint8List.fromList)
          .toList();

      await client.signMessages(messages: messages, addresses: addresses);
    }
    await session.close();
  }

  Future<void> signAndSendTransactions(int number) async {
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    final client = await session.start();
    if (await _doReauthorize(client)) {
      final signer = publicKey!;
      final blockhash = await _solanaClient.rpcClient
          .getLatestBlockhash()
          .then((it) => it.value.blockhash);

      final txs = _generateTransactions(
        number: number,
        signer: signer,
        blockhash: blockhash,
      ).map((e) => e.toByteArray().toList()).map(Uint8List.fromList).toList();

      await client.signAndSendTransactions(transactions: txs);
    }
    await session.close();
  }

  Future<void> signTransactions(int number) async {
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    final client = await session.start();
    if (await _doReauthorize(client)) {
      await _doGenerateAndSignTransactions(client, number);
    }
    await session.close();
  }

  Future<void> authorizeAndSignTransactions() async {
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    final client = await session.start();
    if (await _doAuthorize(client)) {
      await _doGenerateAndSignTransactions(client, 1);
    }
    await session.close();
  }

  Future<void> _doGenerateAndSignTransactions(
      MobileWalletAdapterClient client, int number) async {
    final signer = publicKey!;
    final blockhash = await _solanaClient.rpcClient
        .getLatestBlockhash()
        .then((it) => it.value.blockhash);

    final txs = _generateTransactions(
      number: number,
      signer: signer,
      blockhash: blockhash,
    ).map((e) => e.toByteArray().toList()).map(Uint8List.fromList).toList();

    await client.signTransactions(transactions: txs);
  }

  Future<bool> _doAuthorize(MobileWalletAdapterClient client) async {
    final result = await client.authorize(
        identityUri: Uri.parse('https://solana.com'),
        iconUri: Uri.parse('favicon.ico'),
        identityName: 'Solana',
        cluster: 'mainnet-beta');

    authorizationResult.value = result;
    return result != null;
  }

  Future<bool> _doReauthorize(MobileWalletAdapterClient client) async {
    final authToken = authorizationResult.value?.authToken;
    if (authToken == null) return false;

    final result = await client.reauthorize(
      identityUri: Uri.parse('https://solana.com'),
      iconUri: Uri.parse('favicon.ico'),
      identityName: 'Solana',
      authToken: authToken,
    );

    authorizationResult.value = result;
    return result != null;
  }

  /// Getters
  bool get isAuthorized => authorizationResult.value != null;
  bool get canRequestAirdrop => isAuthorized && !isRequestingAirdrop.value;

  Ed25519HDPublicKey? get publicKey {
    final pk = authorizationResult.value?.publicKey;
    return pk != null ? Ed25519HDPublicKey(pk) : null;
  }

  String? get address => publicKey?.toBase58();
}

/// Helper methods
List<SignedTx> _generateTransactions({
  required int number,
  required Ed25519HDPublicKey signer,
  required String blockhash,
}) {
  final instructions = List.generate(
    number,
    (index) => MemoInstruction(signers: [signer], memo: 'Memo #$index'),
  );

  final signature = Signature(List.filled(64, 0), publicKey: signer);

  return instructions.map(Message.only).map((e) {
    return SignedTx(
      compiledMessage: e.compile(recentBlockhash: blockhash, feePayer: signer),
      signatures: [signature],
    );
  }).toList();
}

List<Message> _generateMessages(
    {required int number, required Ed25519HDPublicKey signer}) {
  return List.generate(
    number,
    (index) => MemoInstruction(signers: [signer], memo: 'Memo #$index'),
  ).map(Message.only).toList();
}
