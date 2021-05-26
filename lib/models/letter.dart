class Letter {
  String title; // 제목
  String content; // 내용
  DateTime arrivedAt; // 도착 예정일
  DateTime sendedAt; // 발송일

  Letter({
    required this.title,
    required this.content,
    required this.arrivedAt,
    required this.sendedAt,
  });

  // 알람 예약시, 편지를 식별하는 고유 아이디가 필요합니다.
  // 편지는 한 번에 1개만 작성 가능하므로, [도착시간 - 작성시간]을 편지의 고유 아이디로 만들 수 있습니다.
  int get id => arrivedAt.millisecondsSinceEpoch - sendedAt.millisecondsSinceEpoch;

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      title: json['title'],
      content: json['content'],
      arrivedAt: DateTime.fromMillisecondsSinceEpoch(json['arrivedAt']),
      sendedAt: DateTime.fromMillisecondsSinceEpoch(json['sendedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['content'] = content;
    _data['arrivedAt'] = arrivedAt.millisecondsSinceEpoch;
    _data['sendedAt'] = sendedAt.millisecondsSinceEpoch;
    return _data;
  }
}
