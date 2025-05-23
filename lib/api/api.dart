import 'dart:developer';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:erebrus_app/config/api_const.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/model/CheckSubscriptionModel.dart';
import 'package:erebrus_app/model/DVPNNodesModel.dart';
import 'package:erebrus_app/model/RegisterVPNClientModel.dart';
import 'package:erebrus_app/model/erebrus/client_model.dart';
import 'package:erebrus_app/view/inAppPurchase/ProFeaturesScreen.dart';
import 'package:erebrus_app/view/profile/profile_model.dart';
import 'package:erebrus_app/view/refer/ReferralsFdModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as ge;
import 'package:get/route_manager.dart';

final dio = Dio();

class ApiController {
  String token = box!.containsKey("token") ? box!.get("token") : "";
  var header = Options(headers: {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${box!.containsKey("token") ? box!.get("token") : ""}"
  });

  googleAppleLogin(
      {required String email,
      required String authType,
      String? appleId}) async {
    try {
      log("message  ${{
        'email': email,
        "authType": authType,
        "appleId": appleId
      }}");
      await dio.post(baseUrl + ApiUrl().googleAppleLogin, data: {
        'email': email,
        "authType": authType,
        "appleId": appleId
      }).then((value) {
        box!.put("email", email);
        box!.put("token", value.data["payload"]["token"]);
        box!.put("uid", value.data["payload"]["userId"]);
        EasyLoading.dismiss();
        box!.put("userType", "web2");
        Get.offAll(() => ProFeaturesScreen(fromLogin: true));
        // Get.offAll(() => const HomeScreen());
      });
    } on DioError catch (e) {
      EasyLoading.dismiss();
      log("----  Google login error  ${e.response}");
    }
  }

  emailAuth({required String email}) async {
    await dio.post(baseUrl + ApiUrl().emailAuth, data: {'email': email}).then(
        (value) {
      Fluttertoast.showToast(msg: "You will receive OTP in your inbox");
    }).catchError((e) {
      log("Email login error");
    });
  }

  Future<ProfileModel> getProfile() async {
    log(header.headers.toString());
    try {
      Response res = await dio.get(
          "https://gateway.netsepio.com/api/v1.0/profile",
          options: header);

      log("profile -  ${res.data}");
      if (res.statusCode == 200) {
        ProfileModel profileModel = ProfileModel.fromJson(res.data);
        if (profileModel.payload != null &&
            profileModel.payload!.walletAddress != null)
          box!.put("ApiWallet", profileModel.payload!.walletAddress!);
        if (profileModel.payload!.google != null)
          box!.put("google", profileModel.payload!.google);
        if (profileModel.payload!.apple != null)
          box!.put("apple", profileModel.payload!.apple);
        if (profileModel.payload!.chainName != null)
          box!.put("chainName", profileModel.payload!.chainName);
        if (profileModel.payload!.name != null)
          box!.put("name", profileModel.payload!.name);

        if (profileModel.payload?.walletAddress != null &&
            (profileModel.payload?.google != null ||
                profileModel.payload?.apple != null)) {
          box?.put("userType", "web3");
        }

        return profileModel;
      }
    } on DioError catch (e) {
      try {
        log("profile -- ${e.response!.toString()}");
        Fluttertoast.showToast(msg: e.response!.data.toString());
      } catch (e) {}
    }
    return ProfileModel();
  }

  Future trialSubscription() async {
    Response res = await dio
        .post("https://gateway.erebrus.io/api/v1.0/subscription/trial",
            options: header)
        .catchError((e) async {
      log("getProfile error-- $e");
      return await Future.error("error");
    });

    log("trialSubscription -  ${res.data}");
    if (res.statusCode == 200) {
      try {
        Fluttertoast.showToast(msg: res.data["status"].toString());
      } catch (e) {}
    }
  }

  Future<CheckSubscriptionModel> checkSubscription() async {
    try {
      Response res = await dio.get(
        "https://gateway.erebrus.io/api/v1.0/subscription",
        options: header,
      );
      // log("checkSubscription -  ${res.data}");
      return await CheckSubscriptionModel.fromJson(res.data);
    } on DioError catch (e) {
      log("checkSubscription error-- ${e.response}");
      return await CheckSubscriptionModel.fromJson(e.response!.data);
    }
  }

  Future getFlowId(
      {required String walletAddress, required String chain}) async {
    var url = baseUrl + ApiUrl().flowid + walletAddress + "&chain=$chain";
    log("Flow Data  ${url}");
    try {
      Response res = await dio.get(url);
      if (res.statusCode == 200) {
        log("Flow Data  ${res.data}");
        getAuthenticate(
            flowid: res.data["payload"]["flowId"].toString(),
            walletAddress: walletAddress);
        return await res.data;
      }
    } on DioError catch (e) {
      log("getFlowId error -- ${e.response}");
    }
  }

  Future<ReferralsFdModel> getReferralFd() async {
    var url = baseUrl + ApiUrl().getReferralFd;
    log("Get ReferralFd  ${url}");
    try {
      Response res = await dio.get(url,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer ${box!.containsKey("token") ? box!.get("token") : ""}"
          }));
      if (res.statusCode == 200) {
        log("ReferralFd Data  ${res.data}");
        return await ReferralsFdModel.fromJson(res.data);
      }
      return ReferralsFdModel();
    } on DioError catch (e) {
      log("getReferralFd error -- ${e.response}");
      return ReferralsFdModel();
    }
  }

  Future getAuthenticate(
      {required String flowid, required String walletAddress}) async {
    Map data = {
      "flowId": flowid,
      "walletAddress": walletAddress,
    };
    // log("Auth data ----- ${jsonEncode(data)}");
    try {
      Response res =
          await dio.post(baseUrl + ApiUrl().authenticate, data: data);

      // log("profile - =-0-=-= ${res.data}");
      if (res.statusCode == 200) {
        log("Flow Data  ${res.data}");
        box!.put("token", res.data["payload"]["token"]);
        box!.put("web3WalletAddress", walletAddress);
        box!.put("userType", "web3Wallet");
        Get.offAll(() => ProFeaturesScreen(fromLogin: true));
        // Get.offAll(() => const BottomBar());
      }
    } on DioError catch (e) {
      log("getAuthenticate error ${e.response!.data}");
    }
  }

  String generateRandomKey(int length) {
    const charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random.secure();
    return List.generate(
        length, (index) => charset[random.nextInt(charset.length)]).join();
  }

  Future<ClientPayload> getVpnData({
    required String selectedString,
    required String privateKey,
    required String collectionId,
  }) async {
    try {
      log(header.headers.toString());
      final key = generateRandomKey(32);
      print(key);
      Map data = {
        "name": "Erebrus",
        "collectionId": collectionId,
        "publickey": privateKey,
      };
      log("API Param  $selectedString -- $data");
      Response res = await dio.post(
        'https://gateway.netsepio.com/api/v1.0/erebrus/client/${selectedString.toLowerCase()}',
        options: header,
        data: data,
      );

      if (res.statusCode == 200) {
        // log('VPN Data get---------------- ${res.data}');
        ErebrusClientModel profileModel = ErebrusClientModel.fromJson(res.data);
        return profileModel.payload!;
      } else {
        var errorMessage = res.data['message'];
        throw Exception(errorMessage);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred',
          colorText: Colors.white, backgroundColor: Colors.red);
      log('Error: $e');
      return ClientPayload(); // Return a default payload or handle as needed
    }
  }

  Future<DVPNNodesModel> getAllNode() async {
    try {
      log(header.headers.toString());
      Response res = await dio.get(
          "https://gateway.erebrus.io/api/v1.0/nodes/active",
          options: header);

      if (res.statusCode == 200) {
        // log('All Node  ---------------- ${res.data}');
        DVPNNodesModel allNodeModel = DVPNNodesModel.fromJson(res.data);
        return allNodeModel;
      } else {
        var errorMessage = res.data['message'];
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Get.snackbar('Error', 'An error occurred',
      //     colorText: Colors.white, backgroundColor: Colors.red);
      log('Error: $e');
      return DVPNNodesModel();
    }
  }

  Future<RegisterClientModel> registerClient(
      nodeId, publickey, presharedKey) async {
    try {
      log(header.headers.toString());
      Response res = await dio.post(
        "https://gateway.erebrus.io/api/v1.0/erebrus/client/$nodeId",
        data: {
          "name": "App",
          "publickey": publickey,
          "presharedKey": presharedKey,
        },
        options: header,
      );

      if (res.statusCode == 200) {
        // log('RegisterClient  ---------------- ${res.data}');
        RegisterClientModel registerClientModel =
            RegisterClientModel.fromJson(res.data);
        return registerClientModel;
      } else {
        EasyLoading.dismiss();
        var errorMessage = res.data['message'];
        throw Exception(errorMessage);
      }
    } on DioError catch (e) {
      EasyLoading.dismiss();
      // Get.snackbar('Error', 'An error occurred',
      //     colorText: Colors.white, backgroundColor: Colors.red);
      log('Error-- : ${e.response}');
      return RegisterClientModel();
    }
  }

  deleteVpn({required String uuid}) async {
    log(header.headers.toString());
    try {
      Response res = await dio
          .delete(
        "https://gateway.netsepio.com/api/v1.0/erebrus/client/$uuid",
        options: header,
      )
          .catchError((e) {
        log(e.toString());
      });

      if (res.statusCode == 200) {
        log('VPN Data delete----------------');
      }
    } on DioError catch (e) {
      log('VPN Data delete ERROR 32 --------------${e.response}');
    }
  }

  deleteVpn2({required String uuid, required String region}) async {
    log(header.headers.toString());
    try {
      var url =
          "https://gateway.netsepio.com/api/v1.0/erebrus/client/$region/$uuid";
      log("url 000-- ===>>>  ${url}");
      Response res = await dio.delete(
        url,
        options: header,
      );

      if (res.statusCode == 200) {
        log('VPN Data delete----------------');
      }
    } on DioError catch (e) {
      log('VPN Data delete ERROR  --------------${e.response}');
    }
  }
}
