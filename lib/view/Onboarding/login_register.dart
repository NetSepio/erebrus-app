import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wire/api/api.dart';
import 'package:wire/components/widgets.dart';
import 'package:wire/config/common.dart';
import 'package:wire/view/home/home.dart';
import 'package:wire/view/profile/profile_model.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 18, 18),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 140),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 50, bottom: 50, left: 20, right: 20),
                    child: Image.asset(
                      "assets/Erebrus_logo_wordmark.png",
                      height: 100,
                      // color: const Color.fromARGB(255, 10, 185, 121),
                    ),
                  ),

                  // sign in button
                  // MyButton(
                  //   customColor: Colors.white.withOpacity(0.7),
                  //   text: "Sign in",
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const SignInPage(),
                  //       ),
                  //     );
                  //   },
                  // ),

                  const SizedBox(height: 20),

                  // // create an account button
                  // MyButton(
                  //   customColor: const Color.fromARGB(255, 10, 185, 121),
                  //   text: "Create an account",
                  //   onTap: () {},
                  // ),
                  // MyButton(
                  //   customColor: const Color.fromARGB(255, 10, 185, 121),
                  //   text: "Import account",
                  //   onTap: () {
                  //     Get.to(() => const ImportAccountScreen());
                  //   },
                  // ),
                  // const SizedBox(height: 20),

                  // MyButton(
                  //   customColor: const Color.fromARGB(255, 10, 185, 121),
                  //   text: "Generate Seed Phrase",
                  //   onTap: () {
                  //     Get.to(() => const GenerateSeedPhrase());
                  //   },
                  // ),
                  const SizedBox(height: 20),
                  MyButton(
                    customColor: const Color.fromARGB(255, 10, 185, 121),
                    text: "Login Using PASETO",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController textEditingController =
                              TextEditingController();
                          return AlertDialog(
                            title: const Text("Enter Auth Token"),
                            content: TextField(
                              controller: textEditingController,
                              decoration: const InputDecoration(
                                hintText: "Paste your PASETO here",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              Center(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        box!.put("token",
                                            textEditingController.text);
                                        ProfileModel ress =
                                            await ApiController().getProfile();
                                        if (ress.status != null &&
                                            ress.status == 200) {
                                          Get.offAll(() => const HomeScreen());
                                        }
                                      } catch (e) {
                                        Get.back();
                                        Fluttertoast.showToast(
                                            msg: "Invalid Auth Token");
                                      }
                                    },
                                    child: const Text("Login")),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),

              const Spacer(),
              // Footer
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Terms of Use",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Privacy Policy",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
