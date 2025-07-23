import 'package:flutter/widgets.dart';

class Responsive {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double scaleWidth(BuildContext context, double value) {
    // 1920 is a common desktop width, adjust as needed
    return value;
  }

  static double scaleHeight(BuildContext context, double value) {
    // 1080 is a common desktop height, adjust as needed
    return value;
  }

  static double scaleText(BuildContext context, double value) {
    // Scale font size based on width
    return value;
  }
}
