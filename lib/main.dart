//Technology is incredible! now you can share and design software with others via the internet.

import 'package:flutter/material.dart';
import 'package:sparkle/screens/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sparkle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey.shade100,
        fontFamily: 'Roboto',
      ),
      home: DashboardScreen(),
    );
  }
}