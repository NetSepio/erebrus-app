import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wire/api/api.dart';
import 'package:wire/components/widgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  RxBool showOtp = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  bool checkTheBox = false;
  check() {
    setState(() {
      checkTheBox = !checkTheBox;
    });
  }

  _handleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final result = await googleSignIn.signIn();
    final ggAuth = await result!.authentication;
    log("idToken - ${ggAuth.idToken}");

    ApiController().googleAuth(idToken: ggAuth.idToken.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 18, 18),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset(
                "assets/images/logo.png",
                color: const Color.fromARGB(255, 10, 185, 121),
                width: 300,
              ),
              const SizedBox(height: 40),
              MyTextField(
                hintText: "Email",
                controller: emailController,
              ),
              const SizedBox(height: 20),
              Obx(
                () => showOtp.value
                    ? MyTextField(
                        hintText: "OTP",
                        controller: otpController,
                      )
                    : const SizedBox(),
              ),
              const SizedBox(height: 20),
              Obx(() => MyButton(
                    customColor: const Color.fromARGB(255, 10, 185, 121),
                    text: showOtp.value ? "Sign in" : "Get OTP",
                    onTap: () async {
                      if (showOtp.value) {
                        await ApiController().emailOTPVerify(
                            email: emailController.text,
                            code: otpController.text);
                      } else {
                        await ApiController()
                            .emailAuth(email: emailController.text);
                        showOtp.value = true;
                      }
                    },
                  )),
              const SizedBox(height: 20),
              const Text(
                "Or sign in with",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _handleSignIn();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Image.asset("assets/images/google.png", width: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
