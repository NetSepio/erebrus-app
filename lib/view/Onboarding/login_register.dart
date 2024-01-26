import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wire/components/widgets.dart';
import 'package:wire/view/Onboarding/signIn.dart';

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
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Image.asset(
                      "assets/images/logo.png",
                      color: const Color.fromARGB(255, 10, 185, 121),
                    ),
                  ),

                  // sign in button
                  MyButton(
                    customColor: Colors.white.withOpacity(0.7),
                    text: "Sign in",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // create an account button
                  MyButton(
                    customColor: const Color.fromARGB(255, 10, 185, 121),
                    text: "Create an account",
                    onTap: () {},
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
                      "Terms of use",
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
