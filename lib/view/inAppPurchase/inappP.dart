import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class FreeTrialButton extends StatefulWidget {
  const FreeTrialButton({Key? key}) : super(key: key);

  @override
  State<FreeTrialButton> createState() => _FreeTrialButtonState();
}

class _FreeTrialButtonState extends State<FreeTrialButton> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _available = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  final Set<String> _productIDs = {
    'first_month',
    'three_month'
  }; // Updated product IDs
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
    initStoreInfo();
    _subscription = _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList);
    });
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _available = isAvailable;
    });

    if (!isAvailable) {
      log('Store not available');
      return;
    }

    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_productIDs);

    if (response.error != null) {
      log('Error fetching product details: ${response.error}');
      Fluttertoast.showToast(
          msg: "Error fetching product details: ${response.error}");
      return;
    }

    if (response.notFoundIDs.isNotEmpty) {
      log('Product IDs not found: ${response.notFoundIDs}');
      Fluttertoast.showToast(
          msg: 'Product IDs not found: ${response.notFoundIDs}');
    }

    if (response.productDetails.isEmpty) {
      log('No products found');
    } else {
      log('Products fetched successfully: ${response.productDetails}');
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        _deliverProduct(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: ${purchaseDetails.error}')),
        );
      }

      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
    setState(() {
      _purchases = purchaseDetailsList;
    });
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) {
    if (_productIDs.contains(purchaseDetails.productID)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Purchase successful: ${purchaseDetails.productID}')),
      );
    }
  }

  void _buyProduct(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  void _restorePurchases() {
    _inAppPurchase.restorePurchases();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_products.isNotEmpty)
          ..._products.map((product) {
            return InkWell(
              onTap: () => _buyProduct(product),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.shade700,
                      Colors.deepPurpleAccent.shade700,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'BUY ${product.title} - ${product.price}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        const SizedBox(height: 10),
      ],
    );
  }
}
