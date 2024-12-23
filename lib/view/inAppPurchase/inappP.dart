import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchasePage extends StatefulWidget {
  @override
  _InAppPurchasePageState createState() => _InAppPurchasePageState();
}

class _InAppPurchasePageState extends State<InAppPurchasePage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _available = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  final String _productID = 'erebrus_plus'; // Your product ID
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
    initStoreInfo();
    _subscription = _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList);
    });
    _listenToPurchaseUpdates();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _available = isAvailable;
    });

    if (!isAvailable) {
      return;
    }

    const Set<String> ids = {'erebrus_plus'};
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(ids);

    if (response.error != null || response.productDetails.isEmpty) {
      log('Error fetching product details 1: ${response.error}');
      Fluttertoast.showToast(
          msg: "Error fetching product details 1: ${response.error}");
      // Handle error or no products found
      return;
    }
    if (response.notFoundIDs.isNotEmpty) {
      log('Product IDs not found 3: ${response.notFoundIDs}');
      Fluttertoast.showToast(
          msg: 'Product IDs not found 3: ${response.notFoundIDs}');
    }

    if (response.productDetails.isEmpty) {
      log('No products found');
    } else {
      log('Products fetched successfully');
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  void _listenToPurchaseUpdates() {
    _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList);
    }, onDone: () {
      log("Featching done");
      // Handle stream closing if necessary
    }, onError: (error) {
      log("Featching Error ---${error}");
      // Handle error
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        _deliverProduct(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
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
    // Unlock content or features for the user
    if (purchaseDetails.productID == _productID) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Purchase successful: ${purchaseDetails.productID}')),
      );
    }
  }

  void _buyProduct(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
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
    return Scaffold(
      appBar: AppBar(title: Text('Select Your Subscription')),
      body: _available
          ? Column(
              children: [
                if (_products.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.shopping_cart, size: 80, color: Colors.grey),
                        Text(
                          'No products available',
                          style: TextStyle(fontSize: 16,
                          //  color: Colors.grey
                           ),
                        ),
                      ],
                    ),
                  ),
                if (_products.isNotEmpty)
                  ..._products.map((product) {
                    return ListTile(
                      title: Text(product.title),
                      subtitle: Text(product.price),
                      trailing: ElevatedButton(
                        onPressed: () => _buyProduct(product),
                        child: Text('Buy'),
                      ),
                    );
                  }).toList(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _restorePurchases,
                  child: Text('Restore Purchases'),
                ),
              ],
            )
          : Center(child: Text('Store not available')),
    );
  }
}
