// To parse this JSON data, do
//
//     final registerClientModel = registerClientModelFromJson(jsonString);

import 'dart:convert';

RegisterClientModel registerClientModelFromJson(String str) => RegisterClientModel.fromJson(json.decode(str));

String registerClientModelToJson(RegisterClientModel data) => json.encode(data.toJson());

class RegisterClientModel {
    final int? status;
    final String? message;
    final RegisterPayload? payload;

    RegisterClientModel({
        this.status,
        this.message,
        this.payload,
    });

    factory RegisterClientModel.fromJson(Map<String, dynamic> json) => RegisterClientModel(
        status: json["status"],
        message: json["message"],
        payload: json["payload"] == null ? null : RegisterPayload.fromJson(json["payload"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "payload": payload?.toJson(),
    };
}

class RegisterPayload {
    final Client? client;
    final String? endpoint;
    final List<String>? serverAddress;
    final String? serverPublicKey;

    RegisterPayload({
        this.client,
        this.endpoint,
        this.serverAddress,
        this.serverPublicKey,
    });

    factory RegisterPayload.fromJson(Map<String, dynamic> json) => RegisterPayload(
        client: json["client"] == null ? null : Client.fromJson(json["client"]),
        endpoint: json["endpoint"],
        serverAddress: json["serverAddress"] == null ? [] : List<String>.from(json["serverAddress"]!.map((x) => x)),
        serverPublicKey: json["serverPublicKey"],
    );

    Map<String, dynamic> toJson() => {
        "client": client?.toJson(),
        "endpoint": endpoint,
        "serverAddress": serverAddress == null ? [] : List<dynamic>.from(serverAddress!.map((x) => x)),
        "serverPublicKey": serverPublicKey,
    };
}

class Client {
    final String? uuid;
    final String? name;
    final bool? enable;
    final String? presharedKey;
    final List<String>? allowedIPs;
    final List<String>? address;
    final int? createdAt;
    final int? updatedAt;

    Client({
        this.uuid,
        this.name,
        this.enable,
        this.presharedKey,
        this.allowedIPs,
        this.address,
        this.createdAt,
        this.updatedAt,
    });

    factory Client.fromJson(Map<String, dynamic> json) => Client(
        uuid: json["UUID"],
        name: json["Name"],
        enable: json["Enable"],
        presharedKey: json["PresharedKey"],
        allowedIPs: json["AllowedIPs"] == null ? [] : List<String>.from(json["AllowedIPs"]!.map((x) => x)),
        address: json["Address"] == null ? [] : List<String>.from(json["Address"]!.map((x) => x)),
        createdAt: json["CreatedAt"],
        updatedAt: json["UpdatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "UUID": uuid,
        "Name": name,
        "Enable": enable,
        "PresharedKey": presharedKey,
        "AllowedIPs": allowedIPs == null ? [] : List<dynamic>.from(allowedIPs!.map((x) => x)),
        "Address": address == null ? [] : List<dynamic>.from(address!.map((x) => x)),
        "CreatedAt": createdAt,
        "UpdatedAt": updatedAt,
    };
}
