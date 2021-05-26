import 'package:from_me/models/letter.dart';
import 'package:from_me/services/local_storage_service.dart';
import 'package:from_me/services/notification_service.dart';

class LetterService {

  // 작성한 편지들을 가지고 있는 변수
  static List<Letter> letters = LocalStorageService.loadLetters();

  // 편지 추가 함수
  static addLetter(Letter letter) {
    // arrivedAt 시간이 과거인 경우
    if (letter.arrivedAt.isBefore(DateTime.now())) {
      // 현재 시간의 3초 뒤로 arrivedAt을 수정합니다.
      letter.arrivedAt = DateTime.now().add(Duration(seconds: 3));
    }

    letters.add(letter);

    // 변경사항 기기에 저장
    LocalStorageService.saveLetters(letters);

    // notification 편지 예약
    NotificationService.sendLetter(letter);
  }

  // 편지 삭제
  static removeLetter(Letter letter) {
    letters.remove(letter);

    // 변경사항 기기에 저장
    LocalStorageService.saveLetters(letters);

    // notification 편지 회수
    NotificationService.recallLetter(letter);
  }
}
