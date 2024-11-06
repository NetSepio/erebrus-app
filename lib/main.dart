import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wire/config/common.dart';
import 'package:wire/view/Onboarding/OnboardingScreen.dart';
import 'package:wire/view/home/home.dart';
import 'package:wire/view/home/home_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await dotenv.load();
  box = await Hive.openBox('wiregard');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
    return GetMaterialApp(
      builder: EasyLoading.init(
        builder: FToastBuilder(),
      ),
      debugShowCheckedModeBanner: false,
      home: box!.containsKey("token")
          ? box!.get("token") != ""
              ? const HomeScreen()
              : const OnboardingScreen()
          : const OnboardingScreen(),
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.green.shade900),
    );
  }
}
