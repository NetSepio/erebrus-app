// To parse this JSON data, do
//
//     final checkSubModel = checkSubModelFromJson(jsonString);

import 'dart:convert';

CheckSubscriptionModel checkSubModelFromJson(String str) => CheckSubscriptionModel.fromJson(json.decode(str));

String checkSubModelToJson(CheckSubscriptionModel data) => json.encode(data.toJson());

class CheckSubscriptionModel {
    final Subscription? subscription;
    final String? status;

    CheckSubscriptionModel({
        this.subscription,
        this.status,
    });

    factory CheckSubscriptionModel.fromJson(Map<String, dynamic> json) => CheckSubscriptionModel(
        subscription: json["subscription"] == null ? null : Subscription.fromJson(json["subscription"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "subscription": subscription?.toJson(),
        "status": status,
    };
}

class Subscription {
    final int? id;
    final String? userId;
    final String? type;
    final DateTime? startTime;
    final DateTime? endTime;

    Subscription({
        this.id,
        this.userId,
        this.type,
        this.startTime,
        this.endTime,
    });

    factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        userId: json["userId"],
        type: json["type"],
        startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
        endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "type": type,
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
    };
}
