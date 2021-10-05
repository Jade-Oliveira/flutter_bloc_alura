import 'package:bytebankapi/screens/counter.dart';
import 'package:bytebankapi/widgets/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: bytebankTheme,
      home: CounterContainer(),
    );
  }
}
