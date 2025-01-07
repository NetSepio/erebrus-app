import 'package:flutter_dotenv/flutter_dotenv.dart';

String baseUrl = dotenv.get("EREBRUS_GATWAY");
String baseUrl2 = dotenv.get("GRAPHQL_URL");

class ApiUrl {
  String googleAuth = "/account/auth-google";
  String registerApple = "/account/register-apple/app";
  String userDetailsAppleId = "/account/user-details-by-apple-id";
  String googleEmailLogin = "/account/auth-google/app";
  String emailAuth = "/account/generate-auth-id";
  String emailOTPVerify = "/account/paseto-from-magic-link";
  String profile = "/profile";
  String subscription = "/subscription";
  String flowid = "/flowid?walletAddress=";
  String authenticate = "/authenticate/NonSign";
  String allNode = "/nodes/active";

  String vpnData = "/erebrus/client";
  String nftCount = "/graphql";
}
