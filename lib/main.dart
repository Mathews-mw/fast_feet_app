import 'package:fast_feet_app/screens/available_orders_screen.dart';
import 'package:fast_feet_app/screens/home_screen.dart';
import 'package:fast_feet_app/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Feet',
      debugShowCheckedModeBanner: false,
      theme: lightModeTheme,
      home: const HomeScreen(),
    );
  }
}
