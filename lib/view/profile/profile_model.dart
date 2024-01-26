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
    final String? email;
    final String? walletAddress;

    Payload({
        this.userId,
        this.email,
        this.walletAddress,
    });

    factory Payload.fromRawJson(String str) => Payload.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        userId: json["userId"],
        email: json["email"],
        walletAddress:json["walletAddress"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "walletAddress":walletAddress,
        "email": email,
    };
}
