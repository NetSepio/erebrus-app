import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color customColor;
  final String? text;
  final String? logoUrl;
  final void Function()? onTap;
  const MyButton({
    super.key,
    required this.customColor,
    this.text,
    this.logoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: customColor,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.blue.shade900,
          //     blurRadius: 20,
          //     spreadRadius: 0.1,
          //   ),
          // ]
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (logoUrl != null)
                Image(
                  image: AssetImage(logoUrl!),
                  height: 25.0,
                ),
              if (logoUrl != null && text != null) SizedBox(width: 20),
              if (text != null)
                Text(
                  text!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
