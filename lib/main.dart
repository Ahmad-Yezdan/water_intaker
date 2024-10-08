import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/pages/home_page.dart';
import 'package:water_intake/providers/water_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => WaterProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Intake',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
          colorSchemeSeed: hexColortoMaterialColor(const Color(0xff9c000f)),
          useMaterial3: true,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: hexColortoMaterialColor(const Color(0xff9c000f)),
          brightness: Brightness.dark),
      home: const HomePage(),
    );
  }
}


MaterialColor hexColortoMaterialColor(Color color) {
  final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
}