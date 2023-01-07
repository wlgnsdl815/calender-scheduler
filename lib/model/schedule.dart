import 'package:drift/drift.dart';

// Table은 drift에서 불러오는 값이고 Schedules는 사용할 테이블 이름으로 class를 만들면 된다
// 아래는 Schedules 테이블의 Column들이다
class Schedules extends Table {
  // 함수를 한 번 더 불러야한다 -> 컬럼을 만드는게 끝났다는 뜻

  //  PRIMARY KEY
  // .autoIncrement() 를 사용하면 PRIMARY KEY를 자동 생성해준다, 사람이 작성하면 실수로 중복을 만들수도 있기에
  // 자동으로 숫자를 늘리라는 뜻의 함수이다
  IntColumn get id => integer().autoIncrement()();

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
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
// 디폴트 값으로 DateTime.now()를 계속 넣어주게 된다. 그러면 나중에 직접 넣을 필요가 없어짐
// 자동으로 insert가 되는 순간에 DateTime.now()가 들어가게 됨
}

// CONTENT, DATE, STARTTIME, ENDTIME, COLORID, CREATEDAT
// 'qwerty', 2022-1-1, 12, 14, 1, 2022-3-5(값을 넣으면 넣어준 값으로 대체가 된다)
// 1
// 2
// 3
