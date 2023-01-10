import 'package:calender_scheduler/component/custom_text_field.dart';
import 'package:calender_scheduler/const/colors.dart';
import 'package:calender_scheduler/database/drift_database.dart';
import 'package:calender_scheduler/model/category_color.dart';
import 'package:drift/drift.dart' show Value;

// show Value 는 drift 패키지에서 Value만 사용하겠다는 뜻이다
// 하지 않으면 Column을 어디서 불러와야 하는 지 몰라서 오류가 난다
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:calender_scheduler/database/drift_database.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

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
                // autovalidateMode: AutovalidateMode.always,
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
                    FutureBuilder<List<CategoryColor>>(
                        future: GetIt.I<LocalDatabase>().getCategoryColors(),
                        builder: (context, snapshot) {
                          // 데이터가 있고 아직 selectedColor가 없고, data가 최소한 하나 이상의 값이 있을 때
                          // selectedColorId 값을 데이터에 있는 첫번째의 id 값으로 설정한다
                          if (snapshot.hasData &&
                              selectedColorId == null &&
                              snapshot.data!.isNotEmpty) {
                            selectedColorId = snapshot.data![0].id;
                          }

                          return _ColorPicker(
                            // 값이 없으면 빈 리스트, 값이 있으면 snapshot.data를 매핑하여 컬러 출력
                            colors: snapshot.hasData
                                ? snapshot.data! // 리스트로 출력
                                : [],
                            selectedColorId: selectedColorId,
                            colorIdSetter: (int id) {
                              setState(() {
                                selectedColorId = id;
                              });
                            },
                          );
                        }),
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

  void onSavePressed() async {
    // formKey는 생성을 했는데 Form 위젯과 결합을 안했을 때
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final key = await GetIt.I<LocalDatabase>().createSchedule(
        SchedulesCompanion(
          date: Value(widget.selectedDate),
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          colorID: Value(selectedColorId!),
        ),
      );

      Navigator.of(context).pop();
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

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({
    Key? key,
    required this.colors,
    required this.selectedColorId,
    required this.colorIdSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // Row 대신 Wrap을 사용하면 화면을 넘어갈 때 자동 줄 바꿈이 된다
      spacing: 8.0, // 좌우 간격
      runSpacing: 10.0, // 위 아래로위 간격
      children: colors
          .map((e) => GestureDetector(
                onTap: () {
                  colorIdSetter(e.id);
                },
                child: renderColor(e, selectedColorId == e.id),
              ))
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(
          int.parse(
            'FF${color.hexCode}',
            radix: 16,
            // hexCode를 16진수로 바꾸어서 FF뒤에 hexCode가 들어오게 한다
          ),
        ),
        border: isSelected
            ? Border.all(
                color: Colors.black,
                width: 4.0,
              )
            : null,
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
