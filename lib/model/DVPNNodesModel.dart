import 'dart:convert';

class DVPNNodesModel {
  int? status;
  String? message;
  List<AllNPayload>? payload;

  DVPNNodesModel({
    this.status,
    this.message,
    this.payload,
  });

  factory DVPNNodesModel.fromRawJson(String str) =>
      DVPNNodesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DVPNNodesModel.fromJson(Map<String, dynamic> json) => DVPNNodesModel(
        status: json["status"],
        message: json["message"],
        payload: json["payload"] == null
            ? []
            : List<AllNPayload>.from(
                json["payload"]!.map((x) => AllNPayload.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "payload": payload == null
            ? []
            : List<dynamic>.from(payload!.map((x) => x.toJson())),
      };
}

class AllNPayload {
  String? id;
  String? name;
  String? httpPort;
  String? domain;
  String? nodename;
  String? address;
  String? region;
  String? status;
  double? downloadSpeed;
  double? uploadSpeed;
  int? startTimeStamp;
  int? lastPingedTimeStamp;
  String? walletAddress;
  String? ipinfoip;
  String? ipinfocity;
  String? ipinfocountry;
  String? ipinfolocation;
  String? ipinfoorg;
  String? ipinfopostal;
  String? ipinfotimezone;
  String? chainName;

  AllNPayload({
    this.id,
    this.name,
    this.httpPort,
    this.domain,
    this.nodename,
    this.address,
    this.region,
    this.status,
    this.downloadSpeed,
    this.uploadSpeed,
    this.startTimeStamp,
    this.lastPingedTimeStamp,
    this.walletAddress,
    this.ipinfoip,
    this.ipinfocity,
    this.ipinfocountry,
    this.ipinfolocation,
    this.ipinfoorg,
    this.ipinfopostal,
    this.ipinfotimezone,
    this.chainName,
  });

  factory AllNPayload.fromRawJson(String str) =>
      AllNPayload.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllNPayload.fromJson(Map<String, dynamic> json) => AllNPayload(
        id: json["id"],
        name: json["name"],
        httpPort: json["httpPort"],
        domain: json["domain"],
        nodename: json["nodename"],
        address: json["address"],
        region: json["region"]!,
        status: json["status"]!,
        downloadSpeed: json["downloadSpeed"]?.toDouble(),
        uploadSpeed: json["uploadSpeed"]?.toDouble(),
        startTimeStamp: json["startTimeStamp"],
        lastPingedTimeStamp: json["lastPingedTimeStamp"],
        walletAddress: json["walletAddress"],
        ipinfoip: json["ipinfoip"],
        ipinfocity: json["ipinfocity"],
        ipinfocountry: json["ipinfocountry"]!,
        ipinfolocation: json["ipinfolocation"],
        ipinfoorg: json["ipinfoorg"],
        ipinfopostal: json["ipinfopostal"],
        ipinfotimezone: json["ipinfotimezone"]!,
        chainName: json["chainName"]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "httpPort": httpPort,
        "domain": domain,
        "nodename": nodename,
        "address": address,
        "region": region,
        "status": status,
        "downloadSpeed": downloadSpeed,
        "uploadSpeed": uploadSpeed,
        "startTimeStamp": startTimeStamp,
        "lastPingedTimeStamp": lastPingedTimeStamp,
        "walletAddress": walletAddress,
        "ipinfoip": ipinfoip,
        "ipinfocity": ipinfocity,
        "ipinfocountry": ipinfocountry,
        "ipinfolocation": ipinfolocation,
        "ipinfoorg": ipinfoorg,
        "ipinfopostal": ipinfopostal,
        "ipinfotimezone": ipinfotimezone,
        "chainName": chainName,
      };
}
