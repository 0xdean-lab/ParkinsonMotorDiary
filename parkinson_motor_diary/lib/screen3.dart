import 'package:flutter/material.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("파킨슨 일기")),
      body: const Center(
        child: Text("마지막 화면입니다."),
      ),
    );
  }
}
