// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers, unnecessary_this
import 'package:bip39/bip39.dart' as bip39;
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/view/Onboarding/wallet_generator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final storage = box;
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
    String? _mnemonic = await storage!.get('mnemonic');
    return _mnemonic;
  }

  Future<void> privateKeyFromMnemonic({String? newMnemonic}) async {
    if (newMnemonic != null) {
      this._mnemonic = newMnemonic;
    }
    await storage!.put('mnemonic', _mnemonic);
    var walletAddress = await WalletGenerator.getAddressFromMnemonic(_mnemonic);
    await storage!.put("accountAddress", walletAddress);
  }
}
