// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers, unnecessary_this
import 'dart:developer';

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erebrus_app/config/secure_storage.dart';
import 'package:erebrus_app/web3dart/web3dart.dart';

class AuthController extends GetxController {
  final storage = SecureStorage();
  bool loading = false;
  final bool _isFingerprintOn = false;

  TextEditingController pincontroller = TextEditingController();
  TextEditingController oldPINcontroller = TextEditingController();
  TextEditingController newPINcontroller = TextEditingController();
  TextEditingController confirmPINcontroller = TextEditingController();
  TextEditingController importAccountphrase = TextEditingController();
  TextEditingController word1 = TextEditingController();
  TextEditingController word4 = TextEditingController();
  TextEditingController word8 = TextEditingController();
  TextEditingController word12 = TextEditingController();
  late String _mnemonic;
  List<String> phrase = [];

  @override
  void onClose() {
    pincontroller.clear();
    oldPINcontroller.clear();
    newPINcontroller.clear();
    confirmPINcontroller.clear();
    importAccountphrase.clear();
    super.onClose();
  }

  Future<bool> approvalCallback() async {
    return true;
  }

  String get mnemonic => _mnemonic;

  String get generateMnemonic => _mnemonic = bip39.generateMnemonic();

  Future<String?> get getMnemonic async {
    String? _mnemonic = await storage.getStoredValue('mnemonic');
    return _mnemonic;
  }

  Future<void> privateKeyFromMnemonic({String? newMnemonic}) async {
    if (newMnemonic != null) {
      this._mnemonic = newMnemonic;
    }
    await storage.writeStoredValues('mnemonic', _mnemonic);
    String pvtKey = Web3.privateKeyFromMnemonic(_mnemonic);
    await storage.writeStoredValues('pvtKey', pvtKey);
    Web3 web3 = Web3(approvalCallback);
    await web3.setCredentials(pvtKey);
    String accountAddress = await web3.getAddress();
    log("Wallet Address $accountAddress");
    await storage.writeStoredValues("accountAddress", accountAddress);
  }
}
