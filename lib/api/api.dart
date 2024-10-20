import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as ge;
import 'package:get/route_manager.dart';
import 'package:wire/config/api_const.dart';
import 'package:wire/config/common.dart';
import 'package:wire/model/AllNodeModel.dart';
import 'package:wire/model/CheckSubModel.dart';
import 'package:wire/model/RegisterClientModel.dart';
import 'package:wire/model/erebrus/client_model.dart';
import 'package:wire/view/bottombar/bottombar.dart';
import 'package:wire/view/home/home.dart';
import 'package:wire/view/profile/profile_model.dart';

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

  googleEmailLogin({String? email}) async {
    await dio.post(baseUrl + ApiUrl().googleEmailLogin,
        data: {'email': email}).then((value) {
      box!.put("token", value.data["payload"]["token"]);
      box!.put("uid", value.data["payload"]["userId"]);
      Get.offAll(() => const HomeScreen());
    }).catchError((e) {
      log("Google login error");
    });
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

      log("profile -  ${res.data}");
      if (res.statusCode == 200) {
        ProfileModel profileModel = ProfileModel.fromJson(res.data);
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
        .catchError((e) {
      log("getProfile error-- $e");
      return Future.error("error");
    });

    log("trialSubscription -  ${res.data}");
    if (res.statusCode == 200) {
      try {
        Fluttertoast.showToast(msg: res.data["status"].toString());
      } catch (e) {}
    }
  }

  Future<CheckSubModel> checkSubscription() async {
    try {
      Response res = await dio.get(
        "https://gateway.erebrus.io/api/v1.0/subscription",
        options: header,
      );
      log("checkSubscription -  ${res.data}");
      return CheckSubModel.fromJson(res.data);
    } on DioException catch (e) {
      log("checkSubscription error-- ${e.response}");
      return CheckSubModel.fromJson(e.response!.data);
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

      log("profile -  ${res.data}");
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

  Future<AllNodeModel> getAllNode() async {
    try {
      log(header.headers.toString());
      Response res = await dio.get(
          "https://gateway.erebrus.io/api/v1.0/nodes/all",
          options: header);

      if (res.statusCode == 200) {
        log('All Node  ---------------- ${res.data}');
        AllNodeModel allNodeModel = AllNodeModel.fromJson(res.data);
        return allNodeModel;
      } else {
        var errorMessage = res.data['message'];
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Get.snackbar('Error', 'An error occurred',
      //     colorText: Colors.white, backgroundColor: Colors.red);
      log('Error: $e');
      return AllNodeModel();
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
        var errorMessage = res.data['message'];
        throw Exception(errorMessage);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred',
          colorText: Colors.white, backgroundColor: Colors.red);
      log('Error: $e');
      return RegisterClientModel();
    }
  }

  deleteVpn({required String uuid}) async {
    log(header.headers.toString());

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
  }

  deleteVpn2({required String uuid, required String region}) async {
    log(header.headers.toString());

    Response res = await dio
        .delete(
      "https://gateway.netsepio.com/api/v1.0/erebrus/client/$region/$uuid",
      options: header,
    )
        .catchError((e) {
      log(e.toString());
    });

    if (res.statusCode == 200) {
      log('VPN Data delete----------------');
    }
  }
}
