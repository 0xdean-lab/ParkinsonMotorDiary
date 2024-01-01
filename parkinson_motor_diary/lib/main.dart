import 'package:flutter/material.dart';
import 'screen1.dart'; // 화면 1에 해당하는 위젯
import 'screen2.dart'; // 화면 2에 해당하는 위젯
import 'screen3.dart'; // 화면 3에 해당하는 위젯

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Screen1(),
    );
  }
}
