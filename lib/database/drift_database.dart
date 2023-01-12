// private 값들은 불러올 수 없다
import 'dart:io';

import 'package:calender_scheduler/model/category_color.dart';
import 'package:calender_scheduler/model/schedule.dart';
import 'package:calender_scheduler/model/shedule_with_color.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// private 값까지 불러올 수 있다
// Database를 연결할 때 part 선언을 해주어야 한다
// 현재파일의 이름 .g.dart
part 'drift_database.g.dart';

//
@DriftDatabase(
  tables: [
    // 괄호 없이 작성한다
    Schedules,
    CategoryColors,
  ],
)
// 사용할 데이터베이스의 이름을 짓고 그 데이터베이스의 이름을 그대로 본따서 extends를 하고 앞에 _$를 붙여준다
// 나중에 flutter에서 이 class 이름을 보고 앞에 _$를 붙여서 새로운 클래스를 part한 파일 안에 만든다
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // 쿼리 작성 - insert schedules
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  // 쿼리 작성 - insert colors
  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  // 쿼리 작성 - get colors
  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  // 쿼리에서 데이터 삭제
  // delete(tbl).go 를하면 그 테이블의 모든 값이 사라지기 때문에 id 값이 같은것만 삭제하도록 만들었다
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  // get을 하면 요청했을 때 한 번 받지만 watch를 하면 Stream으로 값이 업데이트 됐을 때
  // 지속적으로 업데이트 된 값을 받을 수 있다
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    final query = select(schedules).join([
      // 조인을 여러번 할 수 있으니까 리스트로 조인한다
      // categoryColors와 schedules를 조인하는데 categoryColors.id가 schedules.colorID와 같은 것을 조인한다
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorID))
    ]);
    // 조인을 하고 나면 where 문의 tbl 부분을 명시적으로 알려주어야 한다. 어떤 테이블인지
    query.where(schedules.date.equals(date));
    query.orderBy([
      // asc: ascending 오름차순
      // desc: descending 내림차순
      OrderingTerm.asc(schedules.startTime)
    ]);
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ScheduleWithColor(
                  schedule: row.readTable(schedules),
                  categoryColor: row.readTable(categoryColors),
                ),
              )
              .toList(),
        );

    // query 변수에 가져올 값을 제한해서 넣었다
    // schedules 테이블을 select하는데 tbl(테이블)의 date라는 컬럼이 함수에 넣어주는 date(우리가 선택한 날짜)와
    // 같은 경우에만 where로 가져온다
    // 방법 1) final query = select(schedules);
    // query.where((tbl) => tbl.date.equals(date));
    // return query.watch();

    // select(schedules).where((tbl) => tbl.date.equals(date)).watch(); 기존코드
    // where에는 watch()를 사용할 수 없어서 위의 코드 처럼 변수를 만들었다

    // 방법 2)
    // ..이라는 키워드는 함수가 실행이 된 대상이 리턴이 된다
    // 그냥 함수를 select(schedules).where((tbl) => tbl.date.equals(date)) 와 같이 작성하면
    // .이 한개라서 where가 리턴해주는 값이 select(schedules).where((tbl) => tbl.date.equals(date))의 값이지만
    // ..을 해주는 순간 where가 실행이 된 대상 select(schedules)가 리턴이 되기 때문에 .watch()를 사용할 수 있다
    // return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  // 데이터 베이스의 테이블이 바뀌면 schemaVersion도 올려주어야 한다. 초기에는 1로 둔다
  // .g.dart 파일이 생성 되고나면 아래 코드를 작성 해 주어야한다. class 이름에 자동완성 해도 뜨긴 한다
  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;
}

// 하드 드라이브의 어떤 위치에 저장할 지 명시해주어야 한다
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // dbFolder라는 스트림 값 안에 앱을 특정 기기에 설치했을 때 앱 전용으로 사용 할 수 있는 폴더를 가져 올 수 있다
    final dbFolder = await getApplicationDocumentsDirectory();

    // 위 코드로 배정받은 폴더에다가 dbFolder.path로 경로를 가져왔고 'da.splite'라는 파일을 생성한 것이다
    final file = File(p.join(dbFolder.path, 'db.splite'));

    // 파일로 데이터베이스를 만들면 데이터베이스 생성 끝
    return NativeDatabase(file);
  });
}
