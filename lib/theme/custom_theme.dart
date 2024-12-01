import 'package:flutter/material.dart';

class CustomTheme {
  static const padding = 16.0;
  static const double defaultIOSbottomPadding = 20;

  static const primaryColor = Color(0xFF0D66FA);
  static const accentColor = Color(0xFF00FFE1);
  static const bgColor = Color(0xFF070D1B);
  static const faintColor = Color(0xFF222C47);
  static const formColor = Color(0xFF141A30);
  static const opacityColor = Color(0xFF062A67);

  static const color1 = Color(0xFF00FFE1);
  static const color2 = Color(0xFF0D66FA);
  static const color3 = Color(0xFFB53FFF);
  static const color4 = Color(0xFF9EAABA);

  static const successColor = Color(0xFF046C00);
  static const warningColor = Color(0xFFEE4B5C);

  static const inputTextStyle = TextStyle(fontFamily: 'Karla', fontSize: 14, fontWeight: FontWeight.w400);

  static ThemeData get main {
    return ThemeData(
      fontFamily: 'Karla',
      scaffoldBackgroundColor: bgColor,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
      ),
      primarySwatch: primaryColor.material,
      textTheme: const TextTheme(
        bodySmall: TextStyle(fontSize: 14, letterSpacing: 0, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 16, letterSpacing: 0),
        bodyLarge: TextStyle(fontSize: 18, letterSpacing: 0, fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: const Color(0xFF141A30), borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, color: Colors.white70),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(fontFamily: 'Karla', fontSize: 20, fontWeight: FontWeight.w700),
          minimumSize: const Size(0, 52),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: bgColor,
          backgroundColor: Colors.white,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(fontFamily: 'Karla', fontSize: 20, fontWeight: FontWeight.w700),
          minimumSize: const Size(0, 52),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(fontFamily: 'Karla', fontSize: 22, fontWeight: FontWeight.w700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: formColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: padding),
        hintStyle: const TextStyle(color: Color(0xFF9EAABA)),
        errorStyle: const TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 2,
        trackShape: const RectangularSliderTrackShape(),
        overlayShape: SliderComponentShape.noThumb,
        activeTrackColor: primaryColor,
        thumbColor: primaryColor,
      ),
      timePickerTheme: const TimePickerThemeData(
        backgroundColor: Color(0xFF141A30),
        hourMinuteColor: bgColor,
      ),
      datePickerTheme: const DatePickerThemeData(backgroundColor: Color(0xFF141A30)),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        titleTextStyle: const TextStyle(fontFamily: 'Karla', fontSize: 18, fontWeight: FontWeight.w700),
        textColor: Colors.white,
      ),
    );
  }
}

extension ColorAddon on Color {
  MaterialColor get material {
    final colorData = {
      50: withOpacity(.1),
      100: withOpacity(.2),
      200: withOpacity(.3),
      300: withOpacity(.4),
      400: withOpacity(.5),
      500: withOpacity(.6),
      600: withOpacity(.7),
      700: withOpacity(.8),
      800: withOpacity(.9),
      900: withOpacity(1),
    };
    return MaterialColor(value, colorData);
  }

  String get rgbaString {
    return 'rgb($red, $green, $blue, $opacity)';
  }

  String get hexString {
    final r = red.toRadixString(16).padLeft(2, '0');
    final g = green.toRadixString(16).padLeft(2, '0');
    final b = blue.toRadixString(16).padLeft(2, '0');
    return '#$r$g$b';
  }
}
