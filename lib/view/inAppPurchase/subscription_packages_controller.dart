import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:wire/view/inAppPurchase/package_model.dart';

class SubscriptionPackageController extends GetxController {
  RxList<PackageModel> packages = <PackageModel>[].obs;

  RxInt coins = 0.obs;

  final bool kAutoConsume = true;
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> subscription;
  RxList<ProductDetails> products = <ProductDetails>[].obs;
  RxBool isAvailable = false.obs;
  RxString selectedPurchaseId = ''.obs;

  initiate(BuildContext context) {
    // ApiController().getAllPackages().then(
    //   (value) {
    //     if (value.success) {
    //       packages.value = value.packages;
    initStoreInfo();
    // update();
    //     }
    //   },
    // );

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList, context);
    }, onDone: () {
      subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  Future<void> initStoreInfo() async {
    isAvailable.value = await InAppPurchase.instance.isAvailable();
    if (!isAvailable.value) {
      products.value = [];
      update();
      return;
    }

    List<String> kProductIds = packages
        .map((e) =>
            Platform.isIOS ? e.inAppPurchaseIdIOS : e.inAppPurchaseIdAndroid)
        .toList();
    ProductDetailsResponse productDetailResponse =
        await inAppPurchase.queryProductDetails(kProductIds.toSet());

    products.value = productDetailResponse.productDetails;
  }

  showRewardedAds() {
    // RewardedInterstitialAds().show(() {
    //   ApiController().rewardCoins().then((response) {
    //     if (response.success == true) {
    //       getIt<UserProfileManager>().refreshProfile();
    //     } else {}
    //   });
    // })

    ;
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList, BuildContext context) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //showPending error
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          //show error
          Fluttertoast.showToast(
            msg: "purchaseError",
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          //show success

          // AppUtil.checkInternet().then((value) {
          //   if (value) {
          subscribeToPackage(context, purchaseDetails.purchaseID!);
          // ApiController()
          //     .subscribePackage(
          //         packages[selectedPackage.value].id.toString(),
          //         purchaseDetails.purchaseID!,
          //         packages[selectedPackage.value].price.toString())
          //     .then((response) {
          //   Fluttertoast.showToast(
          //       context: context,
          //       message: LocalizationString.coinsAdded,
          //       isSuccess: true);
          //   getIt<UserProfileManager>().refreshProfile();
          //   if (response.success) {
          //     user.value.coins = packages[selectedPackage.value].coin;
          //   }
          // });
          // }
          // });
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume &&
              purchaseDetails.productID == selectedPurchaseId.value) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  subscribeToPackage(BuildContext context, String purchaseId) {
    List<PackageModel> boughtPackages = packages.where((package) {
      if (Platform.isIOS) {
        if (package.inAppPurchaseIdIOS == purchaseId) {
          return true;
        } else {
          return false;
        }
      } else {
        if (package.inAppPurchaseIdAndroid == purchaseId) {
          return true;
        } else {
          return false;
        }
      }
    }).toList();

    PackageModel boughtPackage = boughtPackages.first;

    // ApiController()
    //     .subscribePackage(boughtPackage.id.toString(), purchaseId,
    //         boughtPackage.price.toString())
    //     .then((response) {
    Fluttertoast.showToast(
      msg: "coinsAdded",
    );
    // getIt<UserProfileManager>().refreshProfile();
    // if (response.success) {
    //   user.value.coins = boughtPackage.coin;
    // }
    // }
    // );
  }
}
