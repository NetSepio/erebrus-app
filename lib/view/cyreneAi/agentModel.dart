// To parse this JSON data, do
//
//     final agentModel = agentModelFromJson(jsonString);

import 'dart:convert';

AgentModel agentModelFromJson(String str) => AgentModel.fromJson(json.decode(str));

String agentModelToJson(AgentModel data) => json.encode(data.toJson());

class AgentModel {
    List<Agent>? agents;

    AgentModel({
        this.agents,
    });

    factory AgentModel.fromJson(Map<String, dynamic> json) => AgentModel(
        agents: json["agents"] == null ? [] : List<Agent>.from(json["agents"]!.map((x) => Agent.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "agents": agents == null ? [] : List<dynamic>.from(agents!.map((x) => x.toJson())),
    };
}

class Agent {
    String? id;
    String? name;
    List<String>? clients;
    int? port;
    String? domain;
    String? status;
    String? avatarImg;
    String? coverImg;
    String? voiceModel;
    String? organization;

    Agent({
        this.id,
        this.name,
        this.clients,
        this.port,
        this.domain,
        this.status,
        this.avatarImg,
        this.coverImg,
        this.voiceModel,
        this.organization,
    });

    factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json["id"],
        name: json["name"],
        clients: json["clients"] == null ? [] : List<String>.from(json["clients"]!.map((x) => x)),
        port: json["port"],
        domain: json["domain"],
        status: json["status"],
        avatarImg: json["avatar_img"],
        coverImg: json["cover_img"],
        voiceModel: json["voice_model"],
        organization: json["organization"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "clients": clients == null ? [] : List<dynamic>.from(clients!.map((x) => x)),
        "port": port,
        "domain": domain,
        "status": status,
        "avatar_img": avatarImg,
        "cover_img": coverImg,
        "voice_model": voiceModel,
        "organization": organization,
    };
}
