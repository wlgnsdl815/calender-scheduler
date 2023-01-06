import 'package:calender_scheduler/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 플러터 프레임 워크가 준비가 될 때까지 기다릴 수 있다
  // 만약 runApp() 실행전에 플러터 관련 코드가 적혀있으면 위 코드를 꼭 작성해주어야한다.
  // 원래는 runApp()이 실행되면 자동으로 실행된다.

  await initializeDateFormatting(); // intl 패키지 안에 있는 모든 걸 사용가능함 (언어변경)

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
