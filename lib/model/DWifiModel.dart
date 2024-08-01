import 'dart:convert';

class DWifiModel {
    List<DWifiListData>? data;

    DWifiModel({
        this.data,
    });

    factory DWifiModel.fromRawJson(String str) => DWifiModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DWifiModel.fromJson(Map<String, dynamic> json) => DWifiModel(
        data: json["data"] == null ? [] : List<DWifiListData>.from(json["data"]!.map((x) => DWifiListData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class DWifiListData {
    int? id;
    String? gateway;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<Status>? status;
    String? password;
    String? location;
    String? pricePerMin;

    DWifiListData({
        this.id,
        this.gateway,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.password,
        this.location,
        this.pricePerMin,
    });

    factory DWifiListData.fromRawJson(String str) => DWifiListData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DWifiListData.fromJson(Map<String, dynamic> json) => DWifiListData(
        id: json["id"],
        gateway: json["gateway"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        status: json["status"] == null ? [] : List<Status>.from(json["status"]!.map((x) => Status.fromJson(x))),
        password: json["password"],
        location: json["location"],
        pricePerMin: json["price_per_min"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "gateway": gateway,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status == null ? [] : List<dynamic>.from(status!.map((x) => x.toJson())),
        "password": password,
        "location": location,
        "price_per_min": pricePerMin,
    };
}

class Status {
    String? macAddress;
    String? ipAddress;
    DateTime? connectedAt;
    int? totalConnectedTime;
    bool? connected;
    DateTime? lastChecked;
    String? defaultGateway;
    String? manufacturer;
    String? interfaceName;
    String? hostSsid;

    Status({
        this.macAddress,
        this.ipAddress,
        this.connectedAt,
        this.totalConnectedTime,
        this.connected,
        this.lastChecked,
        this.defaultGateway,
        this.manufacturer,
        this.interfaceName,
        this.hostSsid,
    });

    factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        macAddress: json["macAddress"],
        ipAddress: json["ipAddress"],
        connectedAt: json["connectedAt"] == null ? null : DateTime.parse(json["connectedAt"]),
        totalConnectedTime: json["totalConnectedTime"],
        connected: json["connected"],
        lastChecked: json["lastChecked"] == null ? null : DateTime.parse(json["lastChecked"]),
        defaultGateway: json["defaultGateway"],
        manufacturer: json["manufacturer"],
        interfaceName: json["interfaceName"],
        hostSsid: json["hostSSID"],
    );

    Map<String, dynamic> toJson() => {
        "macAddress": macAddress,
        "ipAddress": ipAddress,
        "connectedAt": connectedAt?.toIso8601String(),
        "totalConnectedTime": totalConnectedTime,
        "connected": connected,
        "lastChecked": lastChecked?.toIso8601String(),
        "defaultGateway": defaultGateway,
        "manufacturer": manufacturer,
        "interfaceName": interfaceName,
        "hostSSID": hostSsid,
    };
}
