import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/controller/profileContrller.dart';
import 'package:erebrus_app/view/Onboarding/OnboardingScreen.dart';
import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:erebrus_app/view/inAppPurchase/ProFeaturesScreen.dart';
import 'package:erebrus_app/view/privacy_consent/privacy_consent_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:upgrader/upgrader.dart';

ThemeMode themeMode = ThemeMode.system;
const String appEnvironmentFor = "erebrus";
PackageInfo? packageInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await dotenv.load();
  box = await Hive.openBox('erebrus');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  if (box!.get("appMode") == null) {
    box!.put("appMode", 'basic');
  }
  packageInfo = await PackageInfo.fromPlatform();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    Get.put(ProfileController());
    return GetMaterialApp(
      builder: EasyLoading.init(
        builder: FToastBuilder(),
      ),
      debugShowCheckedModeBanner: false,
      home: UpgradeAlert(
        dialogStyle: UpgradeDialogStyle.cupertino,
        upgrader: Upgrader(
          durationUntilAlertAgain: Duration(minutes: 10),
        ),
        child: box!.containsKey("token")
            ? box!.get("token") != ""
                ? ProFeaturesScreen(fromLogin: true)
                : PrivacyConsentScreen()
            : PrivacyConsentScreen(),
      ),
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.green.shade900),
    );
  }
}
