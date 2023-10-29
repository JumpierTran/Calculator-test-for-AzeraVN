import 'package:calculation/calculate.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:calculation/history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculate test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white38),
        useMaterial3: true,
      ),
      home: const CalculateScreen(),
    );
  }
}
