// import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';
// import 'package:erebrus_app/components/widgets.dart';
// import 'package:erebrus_app/view/Onboarding/signIn.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => SignUpState();
// }

// class SignUpState extends State<SignUp> {
//   bool showPass = false;
//   bool showConfirm = false;
//   showConfPass() {
//     setState(() {
//       showConfirm = !showConfirm;
//     });
//   }

//   showPassword() {
//     setState(() {
//       showPass = !showPass;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Create Account",
//           style: TextStyle(
//             color: Colors.grey,
//             fontSize: 14,
//           ),
//         ),
//         leading: InkWell(
//             onTap: () {
//               Get.back();
//             },
//             child: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.grey,
//             )),
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//       ),
//       backgroundColor: const Color.fromARGB(255, 19, 18, 18),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 40),
//               const MyTextField(hintText: "Name"),
//               const SizedBox(height: 12),
//               const MyTextField(hintText: "Email"),
//               const SizedBox(height: 12),
//               MyTextField(
//                 hintText: "Password",
//                 onPressed: showPassword,
//                 icon: showPass ? Icons.visibility_off : Icons.visibility,
//                 obscureText: showPass ? false : true,
//               ),
//               const SizedBox(height: 12),
//               MyTextField(
//                 hintText: "Confirm password",
//                 onPressed: showConfPass,
//                 icon: showConfirm ? Icons.visibility_off : Icons.visibility,
//                 obscureText: showConfirm ? false : true,
//               ),
//               const SizedBox(height: 30),
//               MyButton(
//                 customColor: const Color.fromARGB(255, 10, 185, 121),
//                 text: "Sign up",
//                 onTap: () {},
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Or sign up with",
//                 style: TextStyle(
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(7),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.grey.shade700),
//                     ),
//                     child: Image.asset("assets/images/facebook.png", width: 20),
//                   ),
//                   const SizedBox(width: 20),
//                   Container(
//                     padding: const EdgeInsets.all(7),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.grey.shade700),
//                     ),
//                     child: Image.asset("assets/images/google.png", width: 20),
//                   ),
//                   const SizedBox(width: 20),
//                   Container(
//                     padding: const EdgeInsets.all(7),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.grey.shade700),
//                     ),
//                     child: Icon(
//                       Icons.apple,
//                       size: 20,
//                       color: Colors.white.withOpacity(0.5),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Already have an account ?",
//                     style: TextStyle(
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SignInPage(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "LOG IN",
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 10, 185, 121),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
