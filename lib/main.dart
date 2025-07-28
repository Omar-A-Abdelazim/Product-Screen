import 'package:flutter/material.dart';
import 'package:task1/Product.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      theme: ThemeData(fontFamily: 'Audiowide'),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProductScreen();
  }
}
