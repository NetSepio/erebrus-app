import 'package:flutter/material.dart';

const grey = Colors.grey;
const white = Colors.white;
const black = Colors.black;
const blue = Color.fromARGB(255, 89, 9, 218);
const darkpurpule = Color(0xff512888);
const blueGray = Color(0xff617D8E);
const midnightBlue = Color.fromARGB(255, 12, 0, 31);
const appcolor = Color(0xff603fef); // Main App Color
const Color lightAppcolor = Color(0xff6a5acd); // Light App Color
const midnightAppcolor = Color(0xff4B0082); // MidLight App Color
const pupalDark = Color(0xff551ADE);
const pupalLight = Color(0xff7136FA);
const pupalLightBlue = Color(0xff5F1DF9);
const pupalBlue = Color(0xff5F1DF9);
const blackrussion = Color.fromARGB(255, 1, 12, 17);

// Light Mode Theme

ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  primaryColor: appcolor,
  brightness: Brightness.light,
  cardColor: white,
  cardTheme: const CardTheme(elevation: 2),
  iconTheme: const IconThemeData(color: appcolor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: appcolor,
    ),
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: black),
    backgroundColor: white,
    elevation: 0,
    actionsIconTheme: IconThemeData(color: black),
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: black,
    ),
  ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Baskerville',
        bodyColor: black,
        displayColor: black,
        decorationColor: black,
      ),
  primaryTextTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Baskerville',
      ),
).copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    },
  ),
);

// Dark Mode Theme
ThemeData darkTheme = ThemeData(
  useMaterial3: false,
  primaryColor: appcolor,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: blackrussion,
  cardTheme: CardTheme(elevation: 2, color: blueGray.withOpacity(0.2)),
  cardColor: midnightBlue.withOpacity(0.4),
  iconTheme: const IconThemeData(color: lightAppcolor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: appcolor,
    ),
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: white),
    elevation: 0,
    backgroundColor: blackrussion,
    actionsIconTheme: IconThemeData(color: white),
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: white,
    ),
  ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Baskerville',
        bodyColor: white,
        displayColor: white,
        decorationColor: white,
      ),
  primaryTextTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Baskerville',
      ),
).copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    },
  ),
);

Gradient gradient = const LinearGradient(
  colors: [
    Colors.black87,
    Color(0xff0F2027),
    Colors.black,
    Colors.black87,
  ],
  begin: Alignment.topRight,
  end: Alignment.bottomRight,
);

Gradient gradient2 = const LinearGradient(
  colors: [Colors.black87, Color(0xff0F2027), Colors.black, Colors.black87],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);
