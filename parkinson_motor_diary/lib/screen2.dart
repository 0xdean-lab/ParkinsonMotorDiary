import 'package:flutter/material.dart';
import 'screen3.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("파킨슨 일기")),
      body: Center(
        child: ElevatedButton(
          child: const Text("다음 화면으로"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Screen3()),
            );
          },
        ),
      ),
    );
  }
}
