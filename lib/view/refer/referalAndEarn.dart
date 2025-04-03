import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:erebrus_app/api/api.dart';
import 'package:erebrus_app/components/widgets.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/view/home/home.dart';
import 'package:erebrus_app/view/refer/ReferralsFdModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({super.key});

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  TextEditingController referralCodeController =
      TextEditingController(text: box!.get("friendReferralCode") ?? '');
  ReferralsFdModel referralsFdModel = ReferralsFdModel();
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    referralsFdModel = await ApiController().getReferralFd();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: referralCodeController,
              readOnly: box!.get("friendReferralCode") == null ? false : true,
              decoration: InputDecoration(
                labelText: "Enter Referral Code",
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                  ),
                ),
                suffix: box!.get("friendReferralCode") == null
                    ? InkWell(
                        onTap: () async {
                          try {
                            log("toke 0-${"Bearer ${box!.get("token")}"}");
                            var res = await dio.patch(
                                'https://gateway.netsepio.com/api/v1.0/referral/account',
                                options: Options(headers: {"Authorization": "Bearer ${box!.get("token")}"}),
                                data: {
                                  'referralCode': referralCodeController.text
                                });
                            if (res.statusCode == 200) {
                              log("res-- ${res.data}");

                              Fluttertoast.showToast(
                                  msg: "${res.data["message"]}");
                              box!.put("friendReferralCode",
                                  referralCodeController.text);
                              setState(() {});
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Invalid Referral Code");
                            }
                          } on DioException catch (e) {
                            log("message: ${e.response!.data}");

                            Fluttertoast.showToast(
                                msg: "${e.response!.data["message"]}");
                          }
                        },
                        child: Text("Validate"))
                    : Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => (profileController.profileModel.value.payload != null &&
                    profileController
                            .profileModel.value.payload!.referralCode !=
                        null)
                ? Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          onTap: null,
                          maxLines: 4,
                          minLines: 1,
                          controller: TextEditingController(
                            text: profileController
                                .profileModel.value.payload!.referralCode
                                .toString(),
                          ),
                          decoration: InputDecoration(
                            labelText: "My Referral Code",
                            suffixIcon: InkWell(
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: profileController.profileModel.value
                                          .payload!.referralCode
                                          .toString()));
                                  Fluttertoast.showToast(msg: "Copied");
                                },
                                child: Icon(Icons.copy)),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox()),
            SizedBox(height: 20),
            MyButton(
              customColor: Color(0xff0162FF),
              text: "Invite Friends",
              onTap: () async {
                await Share.share(
                    'Install erebrus & get 7 days free trial. Use my referral code: ${box!.get("referralCode")}\nhttps://play.google.com/store/apps/details?id=com.erebrus.app',
                    subject: 'Erebrus');
              },
            ),
            SizedBox(height: 20),
            if (referralsFdModel.payload != null)
              Text(
                "You Referred ${referralsFdModel.payload!.length} Friends",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            if (referralsFdModel.payload != null)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: referralsFdModel.payload!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(referralsFdModel.payload![index].id.toString()),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
