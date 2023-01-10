// private 값들은 불러올 수 없다
import 'dart:io';

import 'package:calender_scheduler/model/category_color.dart';
import 'package:calender_scheduler/model/schedule.dart';
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
