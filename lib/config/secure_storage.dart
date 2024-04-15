import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  Future<String?> getStoredValue(String key) async {
    return await storage.read(key: key);
  }

  Future<Map<String, String>> getAllStoredValues() async {
    Map<String, String> allValues = await storage.readAll();
    return allValues;
  }

  Future<void> deleteStoredValue(String key) async {
    return await storage.delete(key: key);
  }

  Future<void> deleteAllStoredValues() async {
    return await storage.deleteAll();
  }

  Future<void> writeStoredValues(String key, String value) async {
    return await storage.write(key: key, value: value);
  }
}

class Boxes {
  static Box get getdarkModeBox => Hive.box('darkModeBox');
  static Box get getFingerprintBox => Hive.box('fingerprintBox');
  static Box get getNetworkConfigBox => Hive.box('network_config');
  static Box get getCurrentNetworkBox => Hive.box('current_network');
  // static Box<TokenModel> get getTokenOnCurrentNetworkBox =>
  //     Hive.box<TokenModel>('tokens_on_Network');
  // static Box<TransactionHistory> get getTransactionOnCurrentNetworkBox =>
  //     Hive.box<TransactionHistory>('transaction_on_Network');
}
