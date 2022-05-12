import 'package:flutter/material.dart';
import 'package:record_with_timer/TimerPage.dart';


/** 2022.05.08 code design: jongdroid
 * 해당 서비스는 타이머로 시간을 측정하고 TextField를 통해 텍스트를 입력할 수 있음
 * Notice - 텍스트는 저장되지 않으며 향후 Sharedpreferences를 통해 개선 예정
 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MainTimer(),
      ),
    );
  }
}
