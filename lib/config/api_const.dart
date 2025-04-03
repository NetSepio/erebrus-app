const String baseUrl = 'https://gateway.netsepio.com/api/v1.0';
// const String baseUrl = 'https://gateway.erebrus.com/api/v1.0';
const String baseUrl2 = "https://indexer.mainnet.aptoslabs.com/v1/graphql";

// const String baseUrl = 'https://gateway.dev.netsepio.com/api/v1.0';
// const String baseUrl2 =
//     "https://indexer-testnet.staging.gcp.aptosdev.com/v1/graphql";

class ApiUrl {
  // String googleAuth = "/account/auth-google";
  String registerApple = "/account/register-apple/app";
  String userDetailsAppleId = "/account/user-details-by-apple-id";
  String googleEmailLogin = "/account/auth-google/app";
  String googleAppleLogin = "/account/auth/app";
  String emailAuth = "/account/generate-auth-id";
  String emailOTPVerify = "/account/paseto-from-magic-link";
  String profile = "/profile";
  String subscription = "/subscription";
  String flowid = "/flowid?walletAddress=";
  String authenticate = "/authenticate/NonSign";
  String allNode = "/nodes/active";
  String vpnData = "/erebrus/client";
  String nftCount = "/graphql";
  String getReferralFd = "/referral/account";
}
