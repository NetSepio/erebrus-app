import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:erebrus_app/model/CheckSubscriptionModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as ge;
import 'package:get/route_manager.dart';
import 'package:erebrus_app/config/api_const.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/model/DVPNNodesModel.dart';

import 'package:erebrus_app/model/RegisterVPNClientModel.dart';
import 'package:erebrus_app/model/erebrus/client_model.dart';
import 'package:erebrus_app/view/bottombar/bottombar.dart';
import 'package:erebrus_app/view/home/home.dart';
import 'package:erebrus_app/view/profile/profile_model.dart';

final dio = Dio();

class ApiController {
  String token = box!.containsKey("token") ? box!.get("token") : "";
  var header = Options(headers: {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${box!.containsKey("token") ? box!.get("token") : ""}"
  });
  googleAuth({String? idToken}) async {
    await dio.post(baseUrl + ApiUrl().googleAuth,
        data: {'idToken': idToken}).then((value) {
      box!.put("token", value.data["payload"]["token"]);
      box!.put("uid", value.data["payload"]["userId"]);
      Get.offAll(() => const HomeScreen());
    }).catchError((e) {
      log("Google login error");
    });
  }

  registerApple({required String email, required String appleId}) async {
    try {
      Map data = {'email': email, "appleId": appleId};
      log("message---data----${data}");
      await dio
          .post(baseUrl + ApiUrl().registerApple, data: data)
          .then((value) {
        box!.put("email", email);
        emailLogin(email: email);
      });
      log("Apple Register login Successfully");
      EasyLoading.dismiss();
    } on DioException catch (e) {
      EasyLoading.dismiss();
      if (e.response!.statusCode == 400) {
        emailLogin(email: email);
      }
      log("Apple Register login error--- ${e.response}");
    }
  }

  userDetailsAppleId({required String appleId}) async {
    try {
      await dio.post(baseUrl + ApiUrl().userDetailsAppleId,
          data: {"appleId": appleId}).then((value) {
        if (value.data["payload"]["emailId"] != null) {
          emailLogin(email: value.data["payload"]["emailId"]);
        }
      });
      log("Apple Register login error");
      EasyLoading.dismiss();
    } on DioException catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: e.response!.data["error"].toString());
      log("Apple Register login error--- ${e.response}");
    }
  }

  emailLogin({String? email}) async {
    try {
      await dio.post(baseUrl + ApiUrl().googleEmailLogin,
          data: {'email': email}).then((value) {
        box!.put("email", email);
        box!.put("token", value.data["payload"]["token"]);
        box!.put("uid", value.data["payload"]["userId"]);
        EasyLoading.dismiss();
        Get.offAll(() => const HomeScreen());
      });
    } on DioException catch (e) {
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

  emailOTPVerify({required String email, required String code}) async {
    await dio.post(baseUrl + ApiUrl().emailOTPVerify, data: {
      'emailId': email,
      "code": code,
    }).then((value) {
      box!.put("token", value.data["payload"]["token"]);
      box!.put("uid", value.data["payload"]["userId"]);
      Get.offAll(() => const HomeScreen());
    }).catchError((e) {
      Fluttertoast.showToast(msg: "OTP Not Verify");
      log("Email OTP Verify error");
    });
  }

  Future<ProfileModel> getProfile() async {
    log(header.headers.toString());
    try {
      Response res = await dio.get(
          "https://gateway.netsepio.com/api/v1.0/profile",
          options: header);

      // log("profile -  ${res.data}");
      if (res.statusCode == 200) {
        ProfileModel profileModel = ProfileModel.fromJson(res.data);
        if (profileModel.payload != null &&
            profileModel.payload!.walletAddress != null)
          box!.put("ApiWallet", profileModel.payload!.walletAddress!);
        return profileModel;
      }
    } on DioException catch (e) {
      log("profile -- ${e.response!.toString()}");
      Fluttertoast.showToast(msg: e.response!.data.toString());
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
    } on DioException catch (e) {
      log("checkSubscription error-- ${e.response}");
      return await CheckSubscriptionModel.fromJson(e.response!.data);
    }
  }

  Future getFlowId({required String walletAddress}) async {
    Response res = await dio
        .get(baseUrl + ApiUrl().flowid + walletAddress)
        .catchError((e) {
          log("getFlowId error");
          });
    if (res.statusCode == 200) {
      log("Flow Data  ${res.data}");
      getAuthenticate(
          flowid: res.data["payload"]["flowId"].toString(),
          walletAddress: walletAddress);
      return await res.data;
    }
  }

  Future getAuthenticate(
      {required String flowid, required String walletAddress}) async {
    Map data = {
      "flowId": flowid,
      "walletAddress": walletAddress,
    };
    log("Auth data ----- ${jsonEncode(data)}");
    try {
      Response res =
          await dio.post(baseUrl + ApiUrl().authenticate, data: data);

      log("profile - =-0-=-= ${res.data}");
      if (res.statusCode == 200) {
        log("Flow Data  ${res.data}");
        box!.put("token", res.data["payload"]["token"]);
        Get.offAll(() => const BottomBar());
      }
    } on DioException catch (e) {
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
        log('VPN Data get---------------- ${res.data}');
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
        log('All Node  ---------------- ${res.data}');
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
        log('RegisterClient  ---------------- ${res.data}');
        RegisterClientModel registerClientModel =
            RegisterClientModel.fromJson(res.data);
        return registerClientModel;
      } else {
        EasyLoading.dismiss();
        var errorMessage = res.data['message'];
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
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
    } on DioException catch (e) {
      log('VPN Data delete ERROR 32 --------------${e.response}');
    }
  }

  deleteVpn2({required String uuid, required String region}) async {
    log(header.headers.toString());
    try {
      var url="https://gateway.netsepio.com/api/v1.0/erebrus/client/$region/$uuid";
      Response res = await dio.delete(
        url,
        options: header,
      );

      if (res.statusCode == 200) {
        log('VPN Data delete----------------');
      }
    } on DioException catch (e) {
      log('VPN Data delete ERROR  --------------${e.response}');
    }
  }
}
