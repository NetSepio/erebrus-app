import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wire/config/api_const.dart';
import 'package:wire/config/common.dart';
import 'package:wire/model/erebrus/client_model.dart';
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

  Future<ProfileModel> getProfile() async {
    log(header.headers.toString());
    Response res = await dio
        .get(baseUrl + ApiUrl().profile, options: header)
        .catchError((e) {
      log("Google login error");
    });

    log("profile -  ${res.data}");
    if (res.statusCode == 200) {
      ProfileModel profileModel = ProfileModel.fromJson(res.data);
      return profileModel;
    }
    return ProfileModel();
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
    log(header.headers.toString());
    final key = generateRandomKey(32);
    print(key);
    Map data = {
      "name": "test3434",
      "collectionId":
           collectionId,
          // "0x9745c19d98eC04849a515b122ad5bb1024954e5cch3ee298bf£1a548f2422¢9ac",
      "publickey": privateKey, //"DKaXOigN4qR/rfeDP4+BOE8uSIhXdYQUTekR/SVq7Eo="
    };
    log("APi Param -- $data");
    Response res = await dio
        .post(
            // "${baseUrl + ApiUrl().vpnData}$selectedString",
            'https://gateway.dev.netsepio.com/api/v1.0/erebrus/client/$selectedString',
            options: header,
            data: data)
        .catchError((e) {
      Get.snackbar('Error', 'Delete Your Client',
          colorText: Colors.white, backgroundColor: Colors.red);
      log(e.toString());
    });

    if (res.statusCode == 200) {
      log('VPN Data get---------------- ${res.data}');
      ErebrusClientModel profileModel = ErebrusClientModel.fromJson(res.data);
      return profileModel.payload!;
    }
    return ClientPayload();
  }

  deleteVpn({required String uuid, required String selectedString}) async {
    log(header.headers.toString());
    final key = generateRandomKey(32);
    print(key);

    Response res = await dio
        .delete(
      'https://gateway.dev.netsepio.com/api/v1.0/erebrus/client/$selectedString/$uuid',
      options: header,
    )
        .catchError((e) {
      log(e.toString());
    });

    if (res.statusCode == 200) {
      log('VPN Data delete----------------');
      ErebrusClientModel profileModel = ErebrusClientModel.fromJson(res.data);
    }
  }
  // Future<NftListModel> nfts() async {
  //   var address =
  //       "0xc143aba11d86c6a0d5959eaec1ad18652693768d92daab18f323fd7de1dc9829";
  //   var where = [];
  //   var offset = 0;
  //   var limit = 12;
  //   log(header.headers.toString());
  //   Response res = await dio
  //       .post("https://indexer-testnet.staging.gcp.aptosdev.com/v1/graphql",
  //           // baseUrl2 + ApiUrl().nftCount,
  //           data: {
  //             "query":
  //                 "query getAccountCurrentTokens($address: String!, $where: [current_token_ownerships_v2_bool_exp!]!, $offset: Int, $limit: Int) {\n  current_token_ownerships_v2(\n    where: {owner_address: {_eq: $address}, amount: {_gt: 0}, _or: [{table_type_v1: {_eq: \"0x3::token::TokenStore\"}}, {table_type_v1: {_is_null: true}}], _and: $where}\n    order_by: [{last_transaction_version: desc}, {token_data_id: desc}]\n    offset: $offset\n    limit: $limit\n  ) {\n    amount\n    current_token_data {\n      ...TokenDataFields\n    }\n    last_transaction_version\n    property_version_v1\n    token_properties_mutated_v1\n    is_soulbound_v2\n    is_fungible_v2\n  }\n  current_token_ownerships_v2_aggregate(\n    where: {owner_address: {_eq: $address}, amount: {_gt: 0}}\n  ) {\n    aggregate {\n      count\n    }\n  }\n}\n\nfragment TokenDataFields on current_token_datas_v2 {\n  description\n  token_uri\n  token_name\n  token_data_id\n  current_collection {\n    ...CollectionDataFields\n  }\n  token_properties\n  token_standard\n  cdn_asset_uris {\n    cdn_image_uri\n  }\n}\n\nfragment CollectionDataFields on current_collections_v2 {\n  uri\n  max_supply\n  description\n  collection_name\n  collection_id\n  creator_address\n  cdn_asset_uris {\n    cdn_image_uri\n  }\n}",
  //             "variables": {
  //               "address": address,
  //               "limit": limit,
  //               "offset": offset,
  //               "where": where
  //             },
  //             "operationName": "getAccountCurrentTokens"
  //           },
  //           options: header)
  //       .catchError((e) {
  //     log("NFT error - - ${e.toString()}");
  //   });

  //   if (res.statusCode == 200) {
  //     log(res.data.toString());
  //     NftListModel profileModel = NftListModel.fromJson(res.data);
  //     return profileModel;
  //   }
  //   return NftListModel();
  // }
}
