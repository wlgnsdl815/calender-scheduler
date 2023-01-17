import 'package:calender_scheduler/component/calender.dart';
import 'package:calender_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calender_scheduler/component/schedule_card.dart';
import 'package:calender_scheduler/component/today_banner.dart';
import 'package:calender_scheduler/const/colors.dart';
import 'package:calender_scheduler/database/drift_database.dart';
import 'package:calender_scheduler/model/shedule_with_color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            Calender(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8.0),
            TodayBanner(
              selectedDay: selectedDay,
            ),
            SizedBox(height: 8.0),
            _ScheduleList(selectedDate: selectedDay),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          // 바텀시트가 기본적으로 차지하는 공간은 화면의 반이지만 이것을 전체로 만들어준다
          builder: (_) {
            return ScheduleBottomSheet(selectedDate: selectedDay);
          },
        );
      },
      child: Icon(
        Icons.add,
      ),
      backgroundColor: PRIMARY_COLOR,
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // 화면을 클릭하면 거기가 선택되게
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDate;

  const _ScheduleList({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<List<ScheduleWithColor>>(
          stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // 데이터가 없으면 인디케이터를 리턴
              return Container(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data!.isEmpty) {
              // 데이터가 null은 아닌데 리스트에 아무런 값이 없을때 스케쥴이 없다는 뜻이기 때문에
              return Center(
                child: Text('스케줄이 없습니다'),
              );
            }

            return ListView.separated(
              itemCount: snapshot.data!.length,
              // 몇개의 값을 넣을지 지정 미리 그리지 않고 그려져야 하는 카드의 순서가 되면 그린다 메모리에 굉장히 유리

              separatorBuilder: (context, index) {
                // 각 아이템들 사이에 위젯을 넣어준다
                return SizedBox(height: 8.0);
              },
              itemBuilder: (context, index) {
                final scheduleWithColor = snapshot.data![index];

                // 화면에 카드들이 그려질 때마다 아이템 빌더가 실행된다
                // Dismissible은 스와이프가 가능하게 해준다
                return Dismissible(
                  key: ObjectKey(scheduleWithColor.schedule.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (DismissDirection direction) {
                    GetIt.I<LocalDatabase>()
                        .removeSchedule(scheduleWithColor.schedule.id);
                  },
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        // 바텀시트가 기본적으로 차지하는 공간은 화면의 반이지만 이것을 전체로 만들어준다
                        builder: (_) {
                          return ScheduleBottomSheet(
                            selectedDate: selectedDate,
                            scheduleId: scheduleWithColor.schedule.id,
                          );
                        },
                      );
                    },
                    child: ScheduleCard(
                      startTime: scheduleWithColor.schedule.startTime,
                      endTime: scheduleWithColor.schedule.endTime,
                      content: scheduleWithColor.schedule.content,
                      color: Color(
                        int.parse(
                            'FF${scheduleWithColor.categoryColor.hexCode}',
                            radix: 16),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
