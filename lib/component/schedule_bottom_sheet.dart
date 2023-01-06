import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatelessWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    // viewInsets.bottom을 화면 시스템때문에 가려진 부분의 픽셀을 구할 수 있다.

    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height / 2 + bottomInset,
      // 키보드 가린 만큼 더해주고
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        // 패딩추가
        child: Column(
          children: [
            TextField(),
          ],
        ),
      ),
    );
  }
}
