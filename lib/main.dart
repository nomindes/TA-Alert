import 'package:flutter/material.dart';
import 'package:tadaikoukun/screens/home.dart';
import 'package:tadaikoukun/theme.dart';

void main() {
  runApp(const TAdaikoukun());
}

class TAdaikoukun extends StatelessWidget {
  const TAdaikoukun({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TA代行くん",
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: MaterialTheme.lightScheme().toColorScheme()),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: MaterialTheme.lightScheme().toColorScheme(),
      ),
      home: MyApp(),
    );
  }
}
