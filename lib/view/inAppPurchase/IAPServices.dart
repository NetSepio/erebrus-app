import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPConnection {
  static InAppPurchase? _instance;
  static set instance(InAppPurchase value) {
    _instance = value;
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    return _instance!;
  }
}

class IAPServices extends ChangeNotifier {
  StoreState storeState = StoreState.loading;
  bool buying = false;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<PurchasableProduct> products = [];
  List<PurchasableProduct> purchasedProducts = [];

  final iapConnection = IAPConnection.instance;

  IAPServices() {
    final purchaseUpdated = iapConnection.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    loadPurchases();
  }

  checkIsExpire() {}

  Future<void> loadPurchases() async {
    final available = await iapConnection.isAvailable();

    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }

    final ids = <String>{"pro"};
    final response = await iapConnection.queryProductDetails(ids);
    products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList();
    log(
      "Sub  --- ${products.map((e) => '${e.id} : ${e.status.name}')}",
    );

    storeState = StoreState.available;

    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void setBuying(bool s) {
    buying = s;
    notifyListeners();
  }

  Future<void> buy(String id) async {
    setBuying(true);
    late PurchasableProduct? product;

    try {
      product = products.firstWhere((e) => e.id == id);
    } catch (_) {
      setBuying(false);
      Fluttertoast.showToast(msg: "Product not found!");
      Get.back();
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: product.productDetails);
    await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
    Future.delayed(const Duration(milliseconds: 5000), () => setBuying(false));
  }

  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
    notifyListeners();
  }

  void restorePurchases() async {
    try {
      await iapConnection.restorePurchases().whenComplete(() {
        Fluttertoast.showToast(msg: "Restore Purchases Successfully!");
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      debugPrint('restorePurchases: $e');
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      // var now = DateTime.now().microsecondsSinceEpoch;

      // final transactionTime = purchaseDetails.transactionDate;
      // var isExpired = false;

      // double purchaseValue = 0.0;
      // if (purchaseDetails.productID == "pro_plan_monthly") {
      //   purchaseValue = 0.99;
      // }
    }

    if (purchaseDetails.pendingCompletePurchase) {
      await iapConnection.completePurchase(purchaseDetails);
    }
  }

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    // ignore: avoid_print
    print('IAPError: $error');
  }
}

enum StoreState {
  loading,
  available,
  notAvailable,
}

enum ProductStatus {
  purchasable,
  purchased,
  pending,
}

class PurchasableProduct {
  String get id => productDetails.id;
  String get title => productDetails.title;
  String get description => productDetails.description;
  String get price => productDetails.price;
  ProductStatus status;
  ProductDetails productDetails;

  PurchasableProduct(this.productDetails) : status = ProductStatus.purchasable;
}
