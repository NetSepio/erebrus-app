import 'dart:convert';

class ProfileModel {
    final int? status;
    final String? message;
    final Payload? payload;

    ProfileModel({
        this.status,
        this.message,
        this.payload,
    });

    factory ProfileModel.fromRawJson(String str) => ProfileModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        message: json["message"],
        payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "payload": payload?.toJson(),
    };
}

class Payload {
    final String? userId;
    final String? name;
    final String? email;
    final String? google;
    final String? apple;
    final String? chainName;
    final String? walletAddress;
    final String? referralCode;

    Payload({
        this.userId,
        this.email,
        this.name,
        this.google,
        this.apple,
        this.chainName,
        this.walletAddress,
        this.referralCode,
    });

    factory Payload.fromRawJson(String str) => Payload.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        userId: json["userId"],
        email: json["email"],
        name: json["name"],
        google: json["google"],
        apple: json["apple"],
        chainName: json["chainName"],
        walletAddress:json["walletAddress"],
        referralCode:json["referralCode"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "walletAddress":walletAddress,
        "referralCode":referralCode,
        "email": email,
        "name": name,
        "apple": apple,
        "google": google,
        "chainName": chainName,
    };
}
