import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Box? box;

height(double height) => SizedBox(height: height);
width(double width) => SizedBox(width: width);

textFiled(hinttext, {controller}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      border: InputBorder.none,
      hintText: hinttext,
      isDense: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(15.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(15.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(15.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(15.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
  );
}

textFormFiled(hinttext,
    {controller,
    onSubmite,
    textInputAction,
    TextInputType? keyboardType,
    Color? textColor,
    bool? password,
    Widget? suffixIcon,
    bool? enabled,
    String? Function(String?)? validator}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    enabled: enabled,
    textInputAction: textInputAction ?? TextInputAction.next,
    obscureText: password ?? false,
    keyboardType: keyboardType,
    onFieldSubmitted: onSubmite,
    style: TextStyle(color: textColor ?? Colors.black),
    decoration: InputDecoration(
      // fillColor: white,
      filled: true,
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1)),
      hintText: hinttext,
      isDense: true,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
  );
}

class CommonMethod {
  void showSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getXSnackBar(String title, String message, Color? color) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      duration: const Duration(seconds: 2),
      borderRadius: 0,
      barBlur: 10,
    );
  }

  void getXConfirmationSnackBar(
    String title,
    String message,
    Function() onButtonPress,
  ) {
    Get.snackbar(title, message,
        mainButton: TextButton(
          onPressed: onButtonPress,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        isDismissible: true,
        // dismissDirection: SnackDismissDirection.HORIZONTAL,
        duration: const Duration(seconds: 6),
        borderRadius: 0,
        barBlur: 10,
        icon: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            )));
  }
}
