
import 'package:flutter/material.dart';

class Themes {

  static ThemeData mainTheme() => ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue)
          .copyWith(
          brightness: Brightness.dark,
          primary: const Color.fromRGBO(21, 0, 69, 1),
          secondary: const Color.fromRGBO(70, 164, 227, 1),
      ),
  );
}