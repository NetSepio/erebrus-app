class ErebrusClientModel {
  int? status;
  String? message;
  ClientPayload? payload;

  ErebrusClientModel({this.status, this.message, this.payload});

  ErebrusClientModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    payload =
        json['payload'] != null ?  ClientPayload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    return data;
  }
}

class ClientPayload {
  Client? client;
  String? endpoint;
  List<String>? serverAddress;
  String? serverPublicKey;

  ClientPayload(
      {this.client, this.endpoint, this.serverAddress, this.serverPublicKey});

  ClientPayload.fromJson(Map<String, dynamic> json) {
    client =
        json['client'] != null ? new Client.fromJson(json['client']) : null;
    endpoint = json['endpoint'];
    serverAddress = json['serverAddress'].cast<String>();
    serverPublicKey = json['serverPublicKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (client != null) {
      data['client'] = client!.toJson();
    }
    data['endpoint'] = endpoint;
    data['serverAddress'] = serverAddress;
    data['serverPublicKey'] = serverPublicKey;
    return data;
  }
}

class Client {
  String? uUID;
  String? name;
  bool? enable;
  String? publicKey;
  String? presharedKey;
  List<String>? allowedIPs;
  List<String>? address;
  int? createdAt;
  int? updatedAt;

  Client(
      {this.uUID,
      this.name,
      this.enable,
      this.publicKey,
      this.presharedKey,
      this.allowedIPs,
      this.address,
      this.createdAt,
      this.updatedAt});

  Client.fromJson(Map<String, dynamic> json) {
    uUID = json['UUID'];
    name = json['Name'];
    enable = json['Enable'];
    publicKey = json['PublicKey'];
    presharedKey = json['PresharedKey'];
    allowedIPs = json['AllowedIPs'].cast<String>();
    address = json['Address'].cast<String>();
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UUID'] = uUID;
    data['Name'] = name;
    data['Enable'] = enable;
    data['PublicKey'] = publicKey;
    data['PresharedKey'] = presharedKey;
    data['AllowedIPs'] = allowedIPs;
    data['Address'] = address;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    return data;
  }
}
