import 'package:calender_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;

  // true - 시간 // false - 내용
  final bool isTime;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.isTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) rendDerTextField(),
        if (!isTime)
          Expanded(
            child: rendDerTextField(),
          ),
      ],
    );
  }

  Widget rendDerTextField() {
    return TextFormField(
      // null이 return 되면 에러가 없다
      // 에러가 있으면 에러를 String 값으로 리턴해준다
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '값을 입력해주세요';
        }

        if (isTime) {
          int time = int.parse(val);

          if (time < 0) {
            return '0 이상의 숫자를 입력해주세요';
          }
          if (time > 25) {
            return '24 이하의 숫자를 입력해주세요';
          }
        } else {
          if (val.length > 500) {
            return '500자 이하의 긎라를 입력해주세요';
          }
        }
        return null;
      },
      expands: !isTime,
      cursorColor: Colors.grey,

      maxLines: isTime ? 1 : null,
      // 최대 줄의 갯수 null이면 줄이 무한히 내려간다
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      // 시간이면 숫자입력, 시간이 아니면 여러줄로 글을 쓸 수 있는 기능인 multiline

      inputFormatters: isTime
          ? [
              // 블루투스 키보드 같은 걸 사용했을 때 문자 입력이 되는 걸 방지
              FilteringTextInputFormatter.digitsOnly
            ]
          : [
              // 아무것도 작성하지 않으면 제약이 없다
            ],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
