import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:from_me/models/letter.dart';
import 'package:from_me/services/letter_service.dart';
import 'package:intl/intl.dart';

class WritingPage extends StatefulWidget {
  WritingPage({
    Key? key,
    this.onLetterAdded,
  }) : super(key: key);

  final Function? onLetterAdded;

  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  String title = ''; // 제목
  String content = ''; // 내용
  DateTime? arrivedAt; // 도착 예정일(선택이 안된 경우 null이므로 ?를 붙여줍니다)

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()), // 키보드 내리기
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '편지 쓰기',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          elevation: 0, // 그림자 없애기
          backgroundColor: Colors.white, // appBar background color
          iconTheme: IconThemeData(color: Colors.black), // 뒤로가기 버튼 색상
        ),
        backgroundColor: Colors.white, // scaffold background color
        body: SingleChildScrollView(
          // 스크롤 가능하도록 감싸줍니다.
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 가로방향으로 왼쪽 정렬
              children: [
                /// 편지 제목
                TextField(
                  onChanged: (value) => title = value, // 입력시 넘어오는 값을 title에 할당합니다.
                  decoration: InputDecoration(
                    // 테두리를 만듭니다.
                    hintText: '제목', // 입력하는 정보에 대한 안내 문구입니다.
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4), // 테두리를 둥글게 합니다.
                    ),
                  ),
                ),

                SizedBox(height: 16),

                /// 편지 내용
                TextField(
                  onChanged: (value) => content = value, // 입력시 넘어오는 값을 content에 할당합니다.
                  maxLines: 8, // 여러줄 입력 가능하도록
                  decoration: InputDecoration(
                    hintText: '내용',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                /// 도착 예정일 선택 버튼
                Container(
                  width: double.infinity,
                  height: 48, // 버튼 높이
                  child: OutlinedButton(
                    // 테두리 버튼
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        locale: LocaleType.ko, // 한국어로 언어 설정
                        showTitleActions: true, // 취소 및 완료 버튼 추가
                        minTime: DateTime.now(), // 과거 날짜는 선택할 수 없도록 제한
                        currentTime: DateTime.now(), // DatePicker 시작 날짜
                        onConfirm: (date) {
                          // 날짜 선택시 실행되는 함수
                          setState(() => arrivedAt = date);
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.black, // 테두리(border) 색상
                      ),
                    ),
                    child: Text(
                      arrivedAt == null
                          ? '도착 예정일을 선택하세요.' // arrivedAt이 null인 경우
                          : '도착 예정일 : ${DateFormat('yyyy.MM.dd').format(arrivedAt!)}', // arrivedAt이 null이 아닌 경우
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                /// 편지 보내기 버튼
                Container(
                  width: double.infinity,
                  height: 48, // 버튼 높이
                  child: OutlinedButton(
                    // 테두리 버튼
                    onPressed: () {
                      if (title.isEmpty) {
                        // 제목을 입력하지 않은 경우
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 기존에 떠있는 snack 숨기기
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.pinkAccent,
                            content: Text('제목을 입력해주세요.'),
                          ),
                        );
                      } else if (content.isEmpty) {
                        // 내용을 입력하지 않은 경우
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 기존에 떠있는 snack 숨기기
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.pinkAccent,
                            content: Text('내용을 입력해주세요.'),
                          ),
                        );
                      } else if (arrivedAt == null) {
                        // 도착 예정일을 선택하지 않은 경우
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 기존에 떠있는 snack 숨기기
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.pinkAccent,
                            content: Text('도착 예정일을 선택해주세요.'),
                          ),
                        );
                      } else {
                        // 편지 발송!
                        // 작성한 정보를 Letter 객체로 만듭니다.
                        final letter = Letter(
                          title: title,
                          content: content,
                          arrivedAt: arrivedAt!,
                          sendedAt: DateTime.now(),
                        );

                        // LetterService에 작성한 편지를 추가합니다.
                        LetterService.addLetter(letter);

                        ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 기존에 떠있는 snack 숨기기
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.blueAccent,
                            content: Text('편지 발송완료!'),
                          ),
                        );

                        // letterAddedCallBack 호출
                        widget.onLetterAdded?.call();

                        // 홈 화면으로 나가기
                        Navigator.pop(context);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.pinkAccent, // 테두리(border) 색상
                      ),
                    ),
                    child: Text(
                      '편지 보내기',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                /// 안내 문구
                Text(
                  '작성하면 정해둔 날짜까지 삭제. 수정이 불가능합니다.\n제목은 나중에 보여질 내용이니 참고하세요 :)',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
