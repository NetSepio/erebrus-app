import 'dart:convert';

class NftListModel {
    final NftListData? data;

    NftListModel({
        this.data,
    });

    factory NftListModel.fromRawJson(String str) => NftListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NftListModel.fromJson(Map<String, dynamic> json) => NftListModel(
        data: json["data"] == null ? null : NftListData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class NftListData {
    final List<CurrentTokenOwnershipsV2>? currentTokenOwnershipsV2;
    final CurrentTokenOwnershipsV2Aggregate? currentTokenOwnershipsV2Aggregate;

    NftListData({
        this.currentTokenOwnershipsV2,
        this.currentTokenOwnershipsV2Aggregate,
    });

    factory NftListData.fromRawJson(String str) => NftListData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NftListData.fromJson(Map<String, dynamic> json) => NftListData(
        currentTokenOwnershipsV2: json["current_token_ownerships_v2"] == null ? [] : List<CurrentTokenOwnershipsV2>.from(json["current_token_ownerships_v2"]!.map((x) => CurrentTokenOwnershipsV2.fromJson(x))),
        currentTokenOwnershipsV2Aggregate: json["current_token_ownerships_v2_aggregate"] == null ? null : CurrentTokenOwnershipsV2Aggregate.fromJson(json["current_token_ownerships_v2_aggregate"]),
    );

    Map<String, dynamic> toJson() => {
        "current_token_ownerships_v2": currentTokenOwnershipsV2 == null ? [] : List<dynamic>.from(currentTokenOwnershipsV2!.map((x) => x.toJson())),
        "current_token_ownerships_v2_aggregate": currentTokenOwnershipsV2Aggregate?.toJson(),
    };
}

class CurrentTokenOwnershipsV2 {
    final int? amount;
    final CurrentTokenData? currentTokenData;
    final int? lastTransactionVersion;
    final int? propertyVersionV1;
    final dynamic tokenPropertiesMutatedV1;
    final bool? isSoulboundV2;
    final bool? isFungibleV2;

    CurrentTokenOwnershipsV2({
        this.amount,
        this.currentTokenData,
        this.lastTransactionVersion,
        this.propertyVersionV1,
        this.tokenPropertiesMutatedV1,
        this.isSoulboundV2,
        this.isFungibleV2,
    });

    factory CurrentTokenOwnershipsV2.fromRawJson(String str) => CurrentTokenOwnershipsV2.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CurrentTokenOwnershipsV2.fromJson(Map<String, dynamic> json) => CurrentTokenOwnershipsV2(
        amount: json["amount"],
        currentTokenData: json["current_token_data"] == null ? null : CurrentTokenData.fromJson(json["current_token_data"]),
        lastTransactionVersion: json["last_transaction_version"],
        propertyVersionV1: json["property_version_v1"],
        tokenPropertiesMutatedV1: json["token_properties_mutated_v1"],
        isSoulboundV2: json["is_soulbound_v2"],
        isFungibleV2: json["is_fungible_v2"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "current_token_data": currentTokenData?.toJson(),
        "last_transaction_version": lastTransactionVersion,
        "property_version_v1": propertyVersionV1,
        "token_properties_mutated_v1": tokenPropertiesMutatedV1,
        "is_soulbound_v2": isSoulboundV2,
        "is_fungible_v2": isFungibleV2,
    };
}

class CurrentTokenData {
    final String? description;
    final String? tokenUri;
    final String? tokenName;
    final String? tokenDataId;
    final CurrentCollection? currentCollection;
    final dynamic tokenProperties;
    final String? tokenStandard;
    final CdnAssetUris? cdnAssetUris;

    CurrentTokenData({
        this.description,
        this.tokenUri,
        this.tokenName,
        this.tokenDataId,
        this.currentCollection,
        this.tokenProperties,
        this.tokenStandard,
        this.cdnAssetUris,
    });

    factory CurrentTokenData.fromRawJson(String str) => CurrentTokenData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CurrentTokenData.fromJson(Map<String, dynamic> json) => CurrentTokenData(
        description: json["description"],
        tokenUri: json["token_uri"],
        tokenName: json["token_name"],
        tokenDataId: json["token_data_id"],
        currentCollection: json["current_collection"] == null ? null : CurrentCollection.fromJson(json["current_collection"]),
        tokenProperties: json["token_properties"],
        tokenStandard: json["token_standard"],
        cdnAssetUris: json["cdn_asset_uris"] == null ? null : CdnAssetUris.fromJson(json["cdn_asset_uris"]),
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "token_uri": tokenUri,
        "token_name": tokenName,
        "token_data_id": tokenDataId,
        "current_collection": currentCollection?.toJson(),
        "token_properties": tokenProperties,
        "token_standard": tokenStandard,
        "cdn_asset_uris": cdnAssetUris?.toJson(),
    };
}

class CdnAssetUris {
    final dynamic cdnImageUri;

    CdnAssetUris({
        this.cdnImageUri,
    });

    factory CdnAssetUris.fromRawJson(String str) => CdnAssetUris.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CdnAssetUris.fromJson(Map<String, dynamic> json) => CdnAssetUris(
        cdnImageUri: json["cdn_image_uri"],
    );

    Map<String, dynamic> toJson() => {
        "cdn_image_uri": cdnImageUri,
    };
}

class CurrentCollection {
    final String? uri;
    final int? maxSupply;
    final String? description;
    final String? collectionName;
    final String? collectionId;
    final String? creatorAddress;
    final CdnAssetUris? cdnAssetUris;

    CurrentCollection({
        this.uri,
        this.maxSupply,
        this.description,
        this.collectionName,
        this.collectionId,
        this.creatorAddress,
        this.cdnAssetUris,
    });

    factory CurrentCollection.fromRawJson(String str) => CurrentCollection.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CurrentCollection.fromJson(Map<String, dynamic> json) => CurrentCollection(
        uri: json["uri"],
        maxSupply: json["max_supply"],
        description: json["description"],
        collectionName: json["collection_name"],
        collectionId: json["collection_id"],
        creatorAddress: json["creator_address"],
        cdnAssetUris: json["cdn_asset_uris"] == null ? null : CdnAssetUris.fromJson(json["cdn_asset_uris"]),
    );

    Map<String, dynamic> toJson() => {
        "uri": uri,
        "max_supply": maxSupply,
        "description": description,
        "collection_name": collectionName,
        "collection_id": collectionId,
        "creator_address": creatorAddress,
        "cdn_asset_uris": cdnAssetUris?.toJson(),
    };
}

class CurrentTokenOwnershipsV2Aggregate {
    final Aggregate? aggregate;

    CurrentTokenOwnershipsV2Aggregate({
        this.aggregate,
    });

    factory CurrentTokenOwnershipsV2Aggregate.fromRawJson(String str) => CurrentTokenOwnershipsV2Aggregate.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CurrentTokenOwnershipsV2Aggregate.fromJson(Map<String, dynamic> json) => CurrentTokenOwnershipsV2Aggregate(
        aggregate: json["aggregate"] == null ? null : Aggregate.fromJson(json["aggregate"]),
    );

    Map<String, dynamic> toJson() => {
        "aggregate": aggregate?.toJson(),
    };
}

class Aggregate {
    final int? count;

    Aggregate({
        this.count,
    });

    factory Aggregate.fromRawJson(String str) => Aggregate.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Aggregate.fromJson(Map<String, dynamic> json) => Aggregate(
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
    };
}
