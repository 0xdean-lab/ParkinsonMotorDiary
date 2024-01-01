import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:parkinson_motor_diary/sample_screen.dart';
import 'calendar_screen.dart'; // 화면 1에 해당하는 위젯
import 'screen2.dart'; // 화면 2에 해당하는 위젯
import 'screen3.dart'; // 화면 3에 해당하는 위젯
import 'config.dart';

void main() {

  // Init Kakao SDK 
    KakaoSdk.init(
        nativeAppKey: KakaoConfig.nativeAppKey,
        javaScriptAppKey: KakaoConfig.javaScriptAppKey
    );

  // Run App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SampleScreen(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     title: 'Flutter Demo',
  //     home: CalendarScreen(),
  //   );
  // }
}
