// To parse this JSON data, do
//
//     final allNodeModel = allNodeModelFromJson(jsonString);

import 'dart:convert';

AllNodeModel allNodeModelFromJson(String str) => AllNodeModel.fromJson(json.decode(str));

String allNodeModelToJson(AllNodeModel data) => json.encode(data.toJson());

class AllNodeModel {
    final int? status;
    final String? message;
    final List<Payload>? payload;

    AllNodeModel({
        this.status,
        this.message,
        this.payload,
    });

    factory AllNodeModel.fromJson(Map<String, dynamic> json) => AllNodeModel(
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
    final String? id;
    final String? name;
    final String? httpPort;
    final String? domain;
    final String? address;
    final String? region;
    final String? status;
    final double? downloadSpeed;
    final double? uploadSpeed;
    final int? startTimeStamp;
    final int? lastPingedTimeStamp;

    Payload({
        this.id,
        this.name,
        this.httpPort,
        this.domain,
        this.address,
        this.region,
        this.status,
        this.downloadSpeed,
        this.uploadSpeed,
        this.startTimeStamp,
        this.lastPingedTimeStamp,
    });

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        id: json["id"],
        name: json["name"],
        httpPort: json["httpPort"],
        domain: json["domain"],
        address: json["address"],
        region: json["region"],
        status: json["status"],
        downloadSpeed: json["downloadSpeed"]?.toDouble(),
        uploadSpeed: json["uploadSpeed"]?.toDouble(),
        startTimeStamp: json["startTimeStamp"],
        lastPingedTimeStamp: json["lastPingedTimeStamp"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "httpPort": httpPort,
        "domain": domain,
        "address": address,
        "region": region,
        "status": status,
        "downloadSpeed": downloadSpeed,
        "uploadSpeed": uploadSpeed,
        "startTimeStamp": startTimeStamp,
        "lastPingedTimeStamp": lastPingedTimeStamp,
    };
}
