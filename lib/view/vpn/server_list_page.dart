import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class ServerListPage extends StatefulWidget {
  const ServerListPage({
    super.key,
  });

  @override
  _ServerListPageState createState() => _ServerListPageState();
}

class _ServerListPageState extends State<ServerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Servers',
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          GraphQLProvider(
            client: ValueNotifier<GraphQLClient>(
              GraphQLClient(
                link: HttpLink(
                  "https://indexer-testnet.staging.gcp.aptosdev.com/v1/graphql",
                ),
                cache: GraphQLCache(),
              ),
            ),
            child: Query(
              options: QueryOptions(
                document: gql(r'''
    query getAccountCurrentTokens($address: String!, $where: [current_token_ownerships_v2_bool_exp!]!, $offset: Int, $limit: Int) {
      current_token_ownerships_v2(
        where: {owner_address: {_eq: $address}, amount: {_gt: 0}, _or: [{table_type_v1: {_eq: "0x3::token::TokenStore"}}, {table_type_v1: {_is_null: true}}], _and: $where}
        order_by: [{last_transaction_version: desc}, {token_data_id: desc}]
        offset: $offset
        limit: $limit
      ) {
        amount
        current_token_data {
    ...TokenDataFields
        }
        last_transaction_version
        property_version_v1
        token_properties_mutated_v1
        is_soulbound_v2
        is_fungible_v2
      }
      current_token_ownerships_v2_aggregate(
        where: {owner_address: {_eq: $address}, amount: {_gt: 0}}
      ) {
        aggregate {
    count
        }
      }
    }
    
    fragment TokenDataFields on current_token_datas_v2 {
      description
      token_uri
      token_name
      token_data_id
      current_collection {
        ...CollectionDataFields
      }
      token_properties
      token_standard
      cdn_asset_uris {
        cdn_image_uri
      }
    }
    
    fragment CollectionDataFields on current_collections_v2 {
      uri
      max_supply
      description
      collection_name
      collection_id
      creator_address
      cdn_asset_uris {
        cdn_image_uri
      }
    }
    '''),
                variables: const {
                  "address":
                      "0xc143aba11d86c6a0d5959eaec1ad18652693768d92daab18f323fd7de1dc9829",
                  "limit": 12,
                  "offset": 0,
                  "where": [],
                },
                operationName: "getAccountCurrentTokens",
              ),
              builder: (QueryResult result, {refetch, fetchMore}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (result.data == null ||
                    result.data!['current_token_ownerships_v2'] == null) {
                  return const Center(child: Text("No Data"));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: result.data!['current_token_ownerships_v2'].length,
                  itemBuilder: (context, index) {
                    var data =
                        result.data!['current_token_ownerships_v2'][index];
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,

                                  // backgroundImage: ExactAssetImage(
                                  //   freeServers[index].flag!,
                                  // ),
                                ),
                                if (data['current_token_data']["token_uri"] !=
                                    null)
                                  CachedNetworkImage(
                                    imageUrl: data['current_token_data']
                                            ["token_uri"]
                                        .toString()
                                        .replaceFirst('ipfs://',
                                            r'https://nftstorage.link/ipfs/'),
                                    height: 50,
                                    width: 50,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                // Image.network(
                                //   (data['current_token_data']["token_uri"]
                                //       .toString()
                                //       .replaceFirst('ipfs://',
                                //           r'https://nftstorage.link/ipfs/').replaceAll('.json', '')),
                                //   height: 50,
                                //   width: 50,
                                // ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  data["current_token_data"]["description"]
                                      .toString(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            RoundCheckBox(
                              size: 24,
                              checkedWidget: const Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.white,
                              ),
                              borderColor:
                                  const Color.fromRGBO(37, 112, 252, 1),
                              checkedColor:
                                  const Color.fromRGBO(37, 112, 252, 1),
                              isChecked: false,
                              onTap: (x) {},
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Server {
  String? flag;
  String? name;
  String? domain;
  String? username;
  String? password;
  int? port;
  int? mtu;

  Server({
    this.flag,
    this.name,
    this.domain,
    this.username,
    this.password,
    this.port,
    this.mtu,
  });
}
