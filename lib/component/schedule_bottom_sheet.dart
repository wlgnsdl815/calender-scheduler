import 'package:calender_scheduler/component/custom_text_field.dart';
import 'package:calender_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    // viewInsets.bottom을 화면 시스템때문에 가려진 부분의 픽셀을 구할 수 있다.

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        // 화면 빈 곳을 눌렀을 때 키보드 닫힘 하기 위해서는 GestureDetector로 만들어야 함
      },
      child: SafeArea(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          // 키보드 가린 만큼 더해주고
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            // 패딩추가
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 16.0,
              ),
              child: Form(
                key: formKey,
                // 자동으로 검증한다
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(
                      onStartSaved: (String? val) {
                        startTime = int.parse(val!);
                      },
                      onEndSaved: (String? val) {
                        endTime = int.parse(val!);
                      },
                    ),
                    // TextField가 올라오지 않을때는 CMD + Shift + K 누르면 올라온다
                    SizedBox(height: 16.0),
                    _Content(
                      onSaved: (String? val) {
                        content = val;
                      },
                    ),
                    SizedBox(height: 16.0),
                    _ColorPicker(),
                    SizedBox(height: 8.0),
                    _SaveButton(onPressed: onSavePressed),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed() {
    // formKey는 생성을 했는데 Form 위젯과 결합을 안했을 때
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      print('에러가 없습니다');
      formKey.currentState!.save();

      print('----------------------------');
      print('startTime: $startTime');
      print('endTime: $endTime');
      print('content: $content');
    } else {
      print('에러가 있습니다');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;

  const _Time({
    Key? key,
    required this.onStartSaved,
    required this.onEndSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            onSaved: onStartSaved,
            isTime: true,
            label: '시작 시간',
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: CustomTextField(
            onSaved: onEndSaved,
            isTime: true,
            label: '마감 시간',
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  const _Content({
    Key? key,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        onSaved: onSaved,
        isTime: false,
        label: '내용',
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // Row 대신 Wrap을 사용하면 화면을 넘어갈 때 자동 줄 바꿈이 된다
      spacing: 8.0, // 좌우 간격
      runSpacing: 10.0, // 위 아래로위 간격
      children: [
        renderColor(Colors.red),
        renderColor(Colors.orange),
        renderColor(Colors.yellow),
        renderColor(Colors.green),
        renderColor(Colors.blue),
        renderColor(Colors.indigo),
        renderColor(Colors.purple),
      ],
    );
  }

  Widget renderColor(Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}
