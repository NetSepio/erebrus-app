// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebMarketPlace {
  late Credentials _credentials;
  late Web3Client _client;
  late Future<bool> _approveCb;
  late int _networkId;
  WebMarketPlace(
    Future<bool> Function() approveCb, {
    String? url,
    int? networkId,
    String? defaultCommunityAddress,
    String? communityManagerAddress,
    String? transferManagerAddress,
    String? daiPointsManagerAddress,
    int? defaultGasLimit,
  }) {
    _client = Web3Client(dotenv.env["Mumbai_Testnet"].toString(), Client());
    _networkId = 80001;
    _approveCb = approveCb();
  }
  Future<void> setCredentials(String privateKey) async {
    _credentials = await _client.credentialsFromPrivateKey(privateKey);
  }

  Future<String> getAddress() async {
    return (await _credentials.extractAddress()).toString();
  }



}
