import 'package:calender_scheduler/component/calender.dart';
import 'package:calender_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calender_scheduler/component/schedule_card.dart';
import 'package:calender_scheduler/component/today_banner.dart';
import 'package:calender_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
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
              scheduleCount: 3,
            ),
            SizedBox(height: 8.0),
            _ScheduleList(),
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
    print(selectedDay);
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
            itemCount: 100,
            // 몇개의 값을 넣을지 지정 미리 그리지 않고 그려져야 하는 카드의 순서가 되면 그린다 메모리에 굉장히 유리

            separatorBuilder: (context, index) {
              // 각 아이템들 사이에 위젯을 넣어준다
              return SizedBox(height: 8.0);
            },
            itemBuilder: (context, index) {
              // 화면에 카드들이 그려질 때마다 아이템 빌더가 실행된다
              return ScheduleCard(
                startTime: 8,
                endTime: 9,
                content: '프로그래밍 공부하기. $index',
                color: Colors.red,
              );
            }),
      ),
    );
  }
}
