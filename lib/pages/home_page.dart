import 'package:flutter/material.dart';
import 'package:from_me/pages/reading_page.dart';
import 'package:from_me/pages/writing_page.dart';
import 'package:from_me/services/letter_service.dart';
import 'package:from_me/widgets/ad_banner.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '우편함',
          style: TextStyle(
            color: Colors.black, // 폰트 색상
            fontWeight: FontWeight.bold, // 폰트 두께
          ),
        ),
        backgroundColor: Colors.white, // AppBar 백그라운드 색상
        elevation: 0, // 그림자 없애기
      ),
      backgroundColor: Colors.white, // Scaffold 백그라운드 색상
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              // 부모 가득 채우기
              child: LetterService.letters.isEmpty
                  // LetterService.letters 배열이 비어있는 경우
                  ? Center(
                      // 중앙 정렬
                      child: Text(
                        '우편함에 편지가 없군요!\n\n미래의 나에게 편지를 작성해보세요!',
                        textAlign: TextAlign.center, // 텍스트 정렬
                        style: TextStyle(
                          fontSize: 24, // 폰트 크기
                        ),
                      ),
                    )
                  // LetterService.letters 배열이 비어있지 않은 경우
                  : ListView.builder(
                      itemCount: LetterService.letters.length,
                      itemBuilder: (context, index) {
                        final letter = LetterService.letters[index]; // LetterService에서 Letter를 하나씩 꺼냅니다.
                        final isNotArrived = letter.arrivedAt.isAfter(DateTime.now()); // arrivedAt > now
                        return GestureDetector(
                          onTap: () {
                            if (isNotArrived) {
                              // 기존에 다른 SnackBar가 떠있다면 감춰줍니다.
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.pinkAccent,
                                  content: Text('편지가 아직 도착하지 않았어요!'),
                                ),
                              );
                              return;
                            }

                            // ReadingPage로 이동합니다.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadingPage(
                                  letter: letter,
                                  // 콜백이 호출되면 화면을 갱신합니다.
                                  onLetterDeleted: () => setState(() {}),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black), // 테두리 색상
                              borderRadius: BorderRadius.circular(4), // 테두리를 둥글게 합니다.
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // children들을 왼쪽으로 정렬합니다.
                              children: [
                                Text(
                                  '${DateFormat('yyyy.MM.dd').format(letter.sendedAt)} 발송',
                                ),
                                SizedBox(height: 8),
                                Text(
                                  letter.title,
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: double.infinity, // 텍스트가 한 라인을 가득 채우도록 최대 width를 줍니다.
                                  child: Text(
                                    '${DateFormat('yyyy.MM.dd HH:mm').format(letter.arrivedAt)} 도착 ${isNotArrived ? '예정' : '완료'}',
                                    textAlign: TextAlign.end, // 우측으로 정렬합니다.
                                    style: TextStyle(
                                      color: isNotArrived ? Colors.pinkAccent : Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            AdBanner(),
            // 편지 쓰러가기 버튼
            Container(
              width: double.infinity,
              height: 48, // 버튼 높이
              margin: const EdgeInsets.all(16), // 바깥쪽(margin) 영역
              child: OutlinedButton(
                // 테두리 버튼
                onPressed: () {
                  // 클릭시 호출되는 함수
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WritingPage(
                        onLetterAdded: () {
                          // WritingPage에서 onLetterAdded 함수 호출시 새로고침
                          setState(() {});
                        },
                      ), // WritingPage로 이동
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.black, // 테두리(border) 색상
                  ),
                ),
                child: Text(
                  '편지 쓰러가기',
                  style: TextStyle(
                    color: Colors.black,
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
