import 'package:calender_scheduler/database/drift_database.dart';
import 'package:calender_scheduler/screens/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  // 빨강
  'F44336',
  // 주황
  'FF9800',
  // 노랑
  'FFEB3B',
  // 초록
  'FCAF50',
  // 파랑
  '2196F3',
  // 남색
  '3F51B5',
  // 보라
  '9C27B0',
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 플러터 프레임 워크가 준비가 될 때까지 기다릴 수 있다
  // 만약 runApp() 실행전에 플러터 관련 코드가 적혀있으면 위 코드를 꼭 작성해주어야한다.
  // 원래는 runApp()이 실행되면 자동으로 실행된다.

  await initializeDateFormatting(); // intl 패키지 안에 있는 모든 걸 사용가능함 (언어변경)

  final database = LocalDatabase();

  final colors = await database.getCategoryColors();

  // 아래 코드는 제일 처음 한 번 실행 된 후에는 하드에 저장되기 때문에 더이상 실행되지는 않는다
  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor(
        CategoryColorsCompanion(
          // 값을 넣어 줄때 Value()로 감싸서 넣어주어야 한다
          // Value는 drift안의 함수이다
          hexCode: Value(hexCode),
        ),
      );
    }
  }

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
