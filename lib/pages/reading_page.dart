import 'package:flutter/material.dart';
import 'package:from_me/models/letter.dart';
import 'package:from_me/services/letter_service.dart';
import 'package:intl/intl.dart';

class ReadingPage extends StatelessWidget {
  ReadingPage({
    Key? key,
    required this.letter,
    this.onLetterDeleted,
  }) : super(key: key);

  final Letter letter;
  final Function? onLetterDeleted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          letter.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0, // 그림자 없애기
        backgroundColor: Colors.white, // appBar background color
        iconTheme: IconThemeData(color: Colors.black), // 뒤로가기 버튼 색상
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 편지를 보는란을 밑에있는 button 크기를 제외하고 전체로 채우기
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    // children을 가로방향으로 화면을 가득 채우도록 늘리기
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        letter.content,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 64),
                      Text(
                        '${DateFormat('yy.MM.dd').format(letter.sendedAt)} From. Me',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 삭제할게요! 버튼
            Container(
              width: double.infinity,
              height: 48,
              margin: const EdgeInsets.all(16), // 바깥쪽(margin) 영역
              child: OutlinedButton(
                onPressed: () {
                  // 삭제 확인 다이얼로그 띄위기
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      // AlertDialog 위젯을 이용하면
                      return AlertDialog(
                        title: Text(
                          '정말 삭제할까요?\n삭제시 복구할 수 없어요!',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          // 취소버튼
                          TextButton(
                            // Dialog 닫기
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text(
                              '취소',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ),

                          // 삭제버튼
                          TextButton(
                            onPressed: () {
                              // 편지 삭제
                              LetterService.removeLetter(letter);

                              // 삭제 완료 SnackBar
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.pinkAccent,
                                  content: Text('편지가 삭제되었습니다.'),
                                ),
                              );

                              // HomePage 갱신
                              onLetterDeleted?.call();

                              // dialog 닫기
                              Navigator.pop(dialogContext);

                              // ReadingPage 닫기
                              Navigator.pop(context);
                            },
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                // 테두리 색상
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.pinkAccent),
                ),
                child: Text(
                  '삭제할게요!',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
