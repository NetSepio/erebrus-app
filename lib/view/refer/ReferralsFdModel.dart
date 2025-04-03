// To parse this JSON data, do
//
//     final referralsFdModel = referralsFdModelFromJson(jsonString);

import 'dart:convert';

ReferralsFdModel referralsFdModelFromJson(String str) => ReferralsFdModel.fromJson(json.decode(str));

String referralsFdModelToJson(ReferralsFdModel data) => json.encode(data.toJson());

class ReferralsFdModel {
    int? status;
    String? message;
    List<Payload>? payload;

    ReferralsFdModel({
        this.status,
        this.message,
        this.payload,
    });

    factory ReferralsFdModel.fromJson(Map<String, dynamic> json) => ReferralsFdModel(
        status: json["status"],
        message: json["message"],
        payload: json["payload"] == null ? [] : List<Payload>.from(json["payload"]!.map((x) => Payload.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "payload": payload == null ? [] : List<dynamic>.from(payload!.map((x) => x.toJson())),
    };
}

class Payload {
    String? id;
    String? referrerId;
    String? referredId;
    String? referralCode;
    DateTime? createdAt;

    Payload({
        this.id,
        this.referrerId,
        this.referredId,
        this.referralCode,
        this.createdAt,
    });

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        id: json["id"],
        referrerId: json["referrerId"],
        referredId: json["referredId"],
        referralCode: json["referralCode"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "referrerId": referrerId,
        "referredId": referredId,
        "referralCode": referralCode,
        "createdAt": createdAt?.toIso8601String(),
    };
}
