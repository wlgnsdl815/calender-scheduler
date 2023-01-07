import 'package:drift/drift.dart';

// Table은 drift에서 불러오는 값이고 Schedules는 사용할 테이블 이름으로 class를 만들면 된다
// 아래는 Schedules 테이블의 Column들이다
class Schedules extends Table {
  // 함수를 한 번 더 불러야한다
  //  PRIMARY KEY
  IntColumn get id => integer()();

  // 내용
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작시간
  IntColumn get startTime => integer()();

  // 끝시간
  IntColumn get endTime => integer()();

  // Category Color Table ID
  IntColumn get colorID => integer()();

  // 생성 날짜
  DateTimeColumn get createdAt => dateTime()();
}
