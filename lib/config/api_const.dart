// const String baseUrl = 'https://gateway.netsepio.com/api/v1.0';
// const String baseUrl2 =
//     "https://indexer.mainnet.aptoslabs.com/v1/graphql";

const String baseUrl = 'https://gateway.dev.netsepio.com/api/v1.0';
const String baseUrl2 =
    "https://indexer-testnet.staging.gcp.aptosdev.com/v1/graphql";

class ApiUrl {
  String googleAuth = "/account/auth-google";
  String emailAuth = "/account/generate-auth-id";
  String emailOTPVerify = "/account/paseto-from-magic-link";
  String profile = "/profile";
  String flowid = "/flowid?walletAddress=";
  String authenticate = "/authenticate";
  
  String vpnData = "/erebrus/client";
  String nftCount = "/graphql";
}
